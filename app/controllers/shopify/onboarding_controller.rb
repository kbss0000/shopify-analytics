module Shopify
  class OnboardingController < ApplicationController
    def new
      redirect_to dashboard_path, notice: "Shopify is already connected" if current_tenant.shopify_connected?
    end

    def create
      if current_tenant.update(shopify_params)
        # Test connection
        begin
          client = current_tenant.shopify_client
          client.customers(params: { limit: 1 })
          
          flash[:notice] = "Shopify store connected successfully! Click 'Sync Data' to import your data."
          redirect_to dashboard_path
        rescue Shopify::AuthenticationError
          current_tenant.update(shopify_domain: nil, shopify_access_token: nil)
          flash[:alert] = "Invalid Shopify credentials. Please check your domain and access token."
          render :new, status: :unprocessable_entity
        rescue Shopify::APIError => e
          flash[:alert] = "Error connecting to Shopify: #{e.message}"
          render :new, status: :unprocessable_entity
        end
      else
        flash.now[:alert] = "Please fix the errors below"
        render :new, status: :unprocessable_entity
      end
    end

    private

    def shopify_params
      params.require(:tenant).permit(:shopify_domain, :shopify_access_token)
    end
  end
end
