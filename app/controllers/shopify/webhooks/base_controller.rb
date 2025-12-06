module Shopify
  module Webhooks
    class BaseController < ApplicationController
      skip_before_action :verify_authenticity_token
      skip_before_action :authenticate_tenant!
      
      before_action :verify_shopify_webhook

      def receive
        topic = request.headers['X-Shopify-Topic']
        shopify_domain = request.headers['X-Shopify-Shop-Domain']
        
        tenant = Tenant.find_by(shopify_domain: shopify_domain)
        
        unless tenant
          head :unauthorized
          return
        end

        # Store webhook event for reliability
        event = WebhookEvent.create!(
          tenant: tenant,
          topic: topic,
          shopify_webhook_id: request.headers['X-Shopify-Webhook-Id'],
          payload: params.to_unsafe_h,
          status: :pending
        )

        # Process asynchronously
        ShopifyWebhookJob.perform_later(event.id)

        head :ok
      rescue => e
        Rails.logger.error("Webhook error: #{e.message}")
        head :internal_server_error
      end

      private

      def verify_shopify_webhook
        data = request.body.read
        hmac_header = request.headers['X-Shopify-Hmac-Sha256']
        
        # In a real app, you'd fetch the specific tenant's secret based on the domain header first
        # For simplicity/demo, we assume a global secret or environment variable if single app
        secret = ENV['SHOPIFY_API_SECRET']
        
        digest = OpenSSL::Digest.new('sha256')
        calculated_hmac = Base64.encode64(OpenSSL::HMAC.digest(digest, secret, data)).strip

        unless ActiveSupport::SecurityUtils.secure_compare(calculated_hmac, hmac_header)
          head :unauthorized
        end
        
        request.body.rewind
      end
    end
  end
end
