module Shopify
  class Ingestor
    attr_reader :tenant

    def initialize(tenant)
      @tenant = tenant
      @client = tenant.shopify_client
      raise ArgumentError, "Tenant must have Shopify credentials" unless @client
    end

    def sync_all
      {
        customers: sync_customers,
        products: sync_products,
        orders: sync_orders
      }
    end

    def sync_customers
      count = 0
      page_info = nil

      loop do
        params = { limit: 250 }
        params[:page_info] = page_info if page_info

        response = @client.customers(params: params)
        customers_data = response['customers'] || []

        break if customers_data.empty?

        customers_data.each do |customer_data|
          upsert_customer(customer_data)
          count += 1
        end

        # Check for pagination using Link header
        page_info = @client.extract_page_info_from_response
        break unless page_info
      end

      count
    rescue Shopify::APIError => e
      Rails.logger.error("Failed to sync customers for tenant #{tenant.id}: #{e.message}")
      raise
    end

    def sync_products
      count = 0
      page_info = nil

      loop do
        params = { limit: 250 }
        params[:page_info] = page_info if page_info

        response = @client.products(params: params)
        products_data = response['products'] || []

        break if products_data.empty?

        products_data.each do |product_data|
          upsert_product(product_data)
          count += 1
        end

        # Check for pagination using Link header
        page_info = @client.extract_page_info_from_response
        break unless page_info
      end

      count
    rescue Shopify::APIError => e
      Rails.logger.error("Failed to sync products for tenant #{tenant.id}: #{e.message}")
      raise
    end

    def sync_orders
      count = 0
      page_info = nil

      loop do
        params = { limit: 250, status: 'any' }
        params[:page_info] = page_info if page_info

        response = @client.orders(params: params)
        orders_data = response['orders'] || []

        break if orders_data.empty?

        orders_data.each do |order_data|
          upsert_order(order_data)
          count += 1
        end

        # Check for pagination using Link header
        page_info = @client.extract_page_info_from_response
        break unless page_info
      end

      count
    rescue Shopify::APIError => e
      Rails.logger.error("Failed to sync orders for tenant #{tenant.id}: #{e.message}")
      raise
    end

    private

    def upsert_customer(data)
      customer = tenant.customers.find_or_initialize_by(shopify_id: data['id'].to_s)
      
      customer.assign_attributes(
        email: data['email'],
        first_name: data['first_name'],
        last_name: data['last_name'],
        total_spent_cents: (data['total_spent'].to_f * 100).to_i
      )
      
      customer.save!
      customer
    end

    def upsert_product(data)
      product = tenant.products.find_or_initialize_by(shopify_id: data['id'].to_s)
      
      # Get first variant for price
      variant = data['variants']&.first || {}
      
      product.assign_attributes(
        title: data['title'],
        sku: variant['sku'],
        price_cents: (variant['price'].to_f * 100).to_i
      )
      
      product.save!
      product
    end

    def upsert_order(data)
      order = tenant.orders.find_or_initialize_by(shopify_id: data['id'].to_s)
      
      # Find customer if exists
      customer = nil
      if data['customer'] && data['customer']['id']
        customer = tenant.customers.find_by(shopify_id: data['customer']['id'].to_s)
      end
      
      # Determine order status from Shopify data
      # Shopify uses 'fulfillment_status' and 'financial_status'
      # We'll use fulfillment_status as primary, fallback to financial_status
      status = determine_order_status(data)
      
      order.assign_attributes(
        customer: customer,
        total_price_cents: (data['total_price'].to_f * 100).to_i,
        currency: data['currency'] || 'USD',
        placed_at: data['created_at'] || Time.current,
        status: status
      )
      
      order.save!
      order
    end

    def determine_order_status(data)
      # Priority: fulfillment_status > financial_status
      fulfillment_status = data['fulfillment_status']
      financial_status = data['financial_status']
      
      if fulfillment_status.present?
        case fulfillment_status.downcase
        when 'fulfilled', 'partial'
          'fulfilled'
        when 'unfulfilled', 'restocked'
          'pending'
        else
          fulfillment_status.downcase
        end
      elsif financial_status.present?
        case financial_status.downcase
        when 'paid', 'partially_paid'
          'paid'
        when 'pending', 'authorized'
          'pending'
        when 'refunded', 'partially_refunded', 'voided'
          'cancelled'
        else
          financial_status.downcase
        end
      else
        'pending' # Default status
      end
    end
  end
end
