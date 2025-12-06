class WebhookEvent < ApplicationRecord
  belongs_to :tenant
  
  validates :shopify_webhook_id, presence: true
  validates :topic, presence: true
  validates :payload, presence: true
  
  enum status: { pending: 0, processing: 1, processed: 2, failed: 3 }
end
