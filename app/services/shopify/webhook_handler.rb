module Shopify
  class WebhookHandler
    def initialize(payload, topic, tenant)
      @payload = payload
      @topic = topic
      @tenant = tenant
    end

    def process
      case @topic
      when 'orders/create', 'orders/updated'
        process_order
      when 'customers/create', 'customers/update'
        process_customer
      when 'products/create', 'products/update'
        process_product
      when 'checkouts/create', 'checkouts/update'
        process_checkout
      else
        Rails.logger.warn("Unhandled webhook topic: #{@topic}")
      end
    end

    private

    def process_order
      Shopify::Ingestor.new(@tenant).send(:upsert_order, @payload)
    end

    def process_customer
      Shopify::Ingestor.new(@tenant).send(:upsert_customer, @payload)
    end

    def process_product
      Shopify::Ingestor.new(@tenant).send(:upsert_product, @payload)
    end

    def process_checkout
      # Handle abandoned cart logic here
      # For now, we'll just log it or create a partial order if needed
      # But 'checkouts' are distinct from 'orders'
      if @payload['abandoned_checkout_url'].present?
        # Create a CustomEvent for abandoned cart
        customer = find_or_create_customer_from_checkout(@payload)
        return unless customer

        CustomEvent.create!(
          tenant: @tenant,
          customer: customer,
          event_type: 'cart_abandoned',
          properties: {
            checkout_id: @payload['id'],
            total_price: @payload['total_price'],
            url: @payload['abandoned_checkout_url']
          },
          occurred_at: @payload['updated_at'] || Time.current
        )
      end
    end

    def find_or_create_customer_from_checkout(payload)
      return nil unless payload['customer']
      Shopify::Ingestor.new(@tenant).send(:upsert_customer, payload['customer'])
    end
  end
end
