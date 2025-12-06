class ApplicationController < ActionController::Base
  before_action :authenticate_tenant!
  before_action :set_current_tenant

  private

  def set_current_tenant
    @current_tenant = current_tenant
  end

  def after_sign_in_path_for(resource)
    dashboard_path
  end

  def after_sign_up_path_for(resource)
    if resource.shopify_connected?
      dashboard_path
    else
      shopify_onboarding_path
    end
  end
end
