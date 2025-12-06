class Customer < ApplicationRecord
  # Associations
  belongs_to :tenant
  has_many :orders, dependent: :nullify
  has_many :custom_events, dependent: :nullify

  # Validations
  validates :shopify_id, presence: true, uniqueness: { scope: :tenant_id }
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, allow_nil: true

  # Money-rails for total_spent
  monetize :total_spent_cents, allow_nil: false

  # Scopes
  scope :by_total_spent, -> { order(total_spent_cents: :desc) }
  scope :with_email, -> { where.not(email: nil) }

  # Instance methods
  def full_name
    [first_name, last_name].compact.join(' ').presence || 'Unknown'
  end

  # Update total spent from orders
  def update_total_spent!
    total = orders.sum(:total_price_cents)
    update(total_spent_cents: total)
  end
end
