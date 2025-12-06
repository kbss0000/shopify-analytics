module Shopify
  class SyncController < ApplicationController
    def create
      unless current_tenant.shopify_connected?
        flash[:alert] = "Please connect your Shopify store first"
        redirect_to shopify_onboarding_path and return
      end

      # Enqueue background job
      ShopifySyncJob.perform_later(current_tenant.id)

      flash[:notice] = "Sync started! This may take a few minutes. Refresh the page to see updated data."
      redirect_to dashboard_path
    end
  end
end
