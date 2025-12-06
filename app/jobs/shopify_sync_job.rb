class ShopifySyncJob < ApplicationJob
  queue_as :default

  def perform(tenant_id)
    tenant = Tenant.find(tenant_id)
    
    return unless tenant.shopify_connected?

    ingestor = Shopify::Ingestor.new(tenant)
    
    Rails.logger.info("Starting Shopify sync for tenant #{tenant.id}")
    
    result = ingestor.sync_all
    
    Rails.logger.info("Completed Shopify sync for tenant #{tenant.id}: #{result}")
  rescue StandardError => e
    Rails.logger.error("Shopify sync failed for tenant #{tenant_id}: #{e.message}")
    Rails.logger.error(e.backtrace.join("\n"))
    raise
  end
end
