class ShopifySyncAllTenantsJob < ApplicationJob
  queue_as :default

  def perform
    Rails.logger.info("Starting scheduled sync for all tenants")
    
    Tenant.where.not(shopify_domain: nil).find_each do |tenant|
      next unless tenant.shopify_connected?
      
      ShopifySyncJob.perform_later(tenant.id)
    end
    
    Rails.logger.info("Scheduled sync jobs enqueued for all connected tenants")
  end
end
