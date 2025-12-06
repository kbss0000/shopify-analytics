module Webhooks
  class ProductsController < BaseController
    def create
      product_data = webhook_data

      variant = product_data['variants']&.first || {}

      product = @tenant.products.find_or_initialize_by(shopify_id: product_data['id'].to_s)
      product.assign_attributes(
        title: product_data['title'],
        sku: variant['sku'],
        price_cents: (variant['price'].to_f * 100).to_i
      )
      product.save!

      head :ok
    rescue StandardError => e
      Rails.logger.error("Webhook error: #{e.message}")
      head :unprocessable_entity
    end

    def update
      create # Same logic for update
    end
  end
end
