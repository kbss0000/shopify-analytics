class Order < ApplicationRecord
  # Associations
  belongs_to :tenant
  belongs_to :customer, optional: true

  # Validations
  validates :shopify_id, presence: true, uniqueness: { scope: :tenant_id }
  validates :placed_at, presence: true
  validates :currency, presence: true

  # Money-rails for total_price
  monetize :total_price_cents, allow_nil: false, with_model_currency: :currency

  # Scopes
  scope :recent, -> { order(placed_at: :desc) }
  scope :placed_between, ->(start_date, end_date) { where(placed_at: start_date..end_date) }
  scope :placed_on_date, ->(date) { where(placed_at: date.beginning_of_day..date.end_of_day) }
  scope :this_month, -> { where(placed_at: Time.current.beginning_of_month..Time.current.end_of_month) }
  scope :with_customer, -> { where.not(customer_id: nil) }
  scope :by_status, ->(status) { where(status: status) }
  scope :fulfilled, -> { where(status: 'fulfilled') }
  scope :pending, -> { where(status: 'pending') }

  # Callbacks
  after_save :update_customer_total_spent, if: :saved_change_to_total_price_cents?
  after_destroy :update_customer_total_spent

  private

  def update_customer_total_spent
    customer&.update_total_spent!
  end
end
