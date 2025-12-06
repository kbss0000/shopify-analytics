class Tenant < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :trackable

  # Associations
  has_many :customers, dependent: :destroy
  has_many :orders, dependent: :destroy
  has_many :products, dependent: :destroy
  has_many :custom_events, dependent: :destroy

  # Validations
  validates :name, presence: true
  validates :shopify_domain, uniqueness: true, allow_nil: true
  validates :shopify_domain, format: { with: /\A[a-z0-9\-]+\.myshopify\.com\z/i, message: "must be a valid Shopify domain" }, allow_nil: true

  # Security Note: shopify_access_token is stored in plain text for this assignment.
  # In production, use one of these approaches:
  # 1. Rails 7+ ActiveRecord::Encryption (requires master key setup)
  # 2. attr_encrypted gem (https://github.com/attr-encrypted/attr_encrypted)
  # 3. Rails credentials (encrypted credentials file)
  # 
  # For now, ensure database access is restricted and credentials are secure.

  # Check if Shopify is connected
  def shopify_connected?
    shopify_domain.present? && shopify_access_token.present?
  end

  # Get Shopify API client
  def shopify_client
    return nil unless shopify_connected?
    
    @shopify_client ||= Shopify::Client.new(
      domain: shopify_domain,
      access_token: shopify_access_token
    )
  end
end
