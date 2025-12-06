module Webhooks
  class OrdersController < BaseController
    def create
      order_data = webhook_data

      # Find or create customer
      customer = nil
      if order_data['customer'] && order_data['customer']['id']
        customer = @tenant.customers.find_by(shopify_id: order_data['customer']['id'].to_s)
      end

      order = @tenant.orders.find_or_initialize_by(shopify_id: order_data['id'].to_s)
      
      # Determine order status from Shopify data
      status = determine_order_status(order_data)
      
      order.assign_attributes(
        customer: customer,
        total_price_cents: (order_data['total_price'].to_f * 100).to_i,
        currency: order_data['currency'] || 'USD',
        placed_at: order_data['created_at'] || Time.current,
        status: status
      )
      order.save!

      head :ok
    rescue StandardError => e
      Rails.logger.error("Webhook error: #{e.message}")
      head :unprocessable_entity
    end

    def update
      create # Same logic for update
    end

    private

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
