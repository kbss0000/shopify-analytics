module Webhooks
  class CustomersController < BaseController
    def create
      customer_data = webhook_data

      customer = @tenant.customers.find_or_initialize_by(shopify_id: customer_data['id'].to_s)
      customer.assign_attributes(
        email: customer_data['email'],
        first_name: customer_data['first_name'],
        last_name: customer_data['last_name'],
        total_spent_cents: (customer_data['total_spent'].to_f * 100).to_i
      )
      customer.save!

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
