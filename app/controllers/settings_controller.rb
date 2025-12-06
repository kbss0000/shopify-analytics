class SettingsController < ApplicationController
  before_action :authenticate_tenant!

  def index
  end

  def update
    # Handle form updates if we add more settings later
  end

  def toggle_currency
    session[:currency] = params[:currency]
    redirect_back(fallback_location: settings_path, notice: 'Currency preference updated.')
  end

  def update_account
    # Handle password update separately if provided
    if account_params[:password].present?
      # Devise requires current_password when updating password
      unless account_params[:current_password].present?
        redirect_to settings_path, alert: 'Current password is required to change your password.'
        return
      end
      
      # Update password with Devise's update_with_password
      if current_tenant.update_with_password(account_params)
        bypass_sign_in(current_tenant)
        redirect_to settings_path, notice: 'Password updated successfully.'
        return
      else
        redirect_to settings_path, alert: "Password update failed: #{current_tenant.errors.full_messages.join(', ')}"
        return
      end
    end
    
    # Update name and email without password
    update_params = account_params.except(:password, :password_confirmation, :current_password)
    if current_tenant.update(update_params)
      redirect_to settings_path, notice: 'Account settings updated successfully.'
    else
      redirect_to settings_path, alert: "Error: #{current_tenant.errors.full_messages.join(', ')}"
    end
  end

  private

  def account_params
    params.require(:tenant).permit(:name, :email, :password, :password_confirmation, :current_password)
  end
end