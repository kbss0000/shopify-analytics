Rails.application.routes.draw do
  get 'settings/index'
  get 'up', to: 'health#show' # Standard Rails health check pattern
  
  get 'settings', to: 'settings#index'
  post 'settings/currency', to: 'settings#toggle_currency'
  patch 'settings/account', to: 'settings#update_account'
  
  get 'reports', to: 'reports#index'
  get 'customers', to: 'customers#index'
  get 'orders', to: 'orders#index'
  get 'ai', to: 'ai#index'
  post 'ai/ask', to: 'ai#ask'
  
  get 'dashboard', to: 'dashboard#index'
  post 'shopify/sync', to: 'shopify/sync#create'
  
  # Webhooks
  post 'webhooks/shopify', to: 'shopify/webhooks/base#receive'
  
  namespace :shopify do
    namespace :webhooks do
      post 'orders/create', to: 'orders#create'
      post 'products/create', to: 'products#create'
      post 'customers/create', to: 'customers#create'
    end
  end

  # Shopfy Onboarding
  get 'shopify/onboarding', to: 'shopify/onboarding#new'
  
  devise_for :tenants, controllers: {
    registrations: 'tenants/registrations',
    sessions: 'tenants/sessions'
  }
  
  root "dashboard#index"
end
