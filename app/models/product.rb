class Product < ApplicationRecord
  # Associations
  belongs_to :tenant

  # Validations
  validates :shopify_id, presence: true, uniqueness: { scope: :tenant_id }
  validates :title, presence: true

  # Money-rails for price
  monetize :price_cents, allow_nil: false

  # Scopes
  scope :by_title, -> { order(:title) }
  scope :with_sku, -> { where.not(sku: nil) }
end
