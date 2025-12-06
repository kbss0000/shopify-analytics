module Webhooks
  class BaseController < ActionController::API
    skip_before_action :verify_authenticity_token
    before_action :verify_webhook

    private

    def verify_webhook
      data = request.body.read
      hmac_header = request.headers['X-Shopify-Hmac-SHA256']

      # In production, you should verify the HMAC
      # For now, we'll find tenant by shop domain
      shop_domain = request.headers['X-Shopify-Shop-Domain']
      
      @tenant = Tenant.find_by(shopify_domain: shop_domain)
      
      unless @tenant
        render json: { error: 'Tenant not found' }, status: :not_found
        return
      end

      # TODO: Verify HMAC signature
      # computed_hmac = Base64.strict_encode64(
      #   OpenSSL::HMAC.digest('sha256', webhook_secret, data)
      # )
      # 
      # unless ActiveSupport::SecurityUtils.secure_compare(computed_hmac, hmac_header)
      #   render json: { error: 'Invalid signature' }, status: :unauthorized
      # end
    end

    def webhook_data
      @webhook_data ||= JSON.parse(request.body.read)
    rescue JSON::ParserError
      {}
    end
  end
end
