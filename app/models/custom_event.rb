class CustomEvent < ApplicationRecord
  belongs_to :customer
  belongs_to :tenant

  validates :event_type, presence: true
  validates :occurred_at, presence: true

  # Scopes for common queries
  scope :recent, -> { order(occurred_at: :desc) }
  scope :by_type, ->(type) { where(event_type: type) }
end