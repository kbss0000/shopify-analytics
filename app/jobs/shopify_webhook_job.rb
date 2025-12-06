class ShopifyWebhookJob < ApplicationJob
  queue_as :default

  def perform(webhook_event_id)
    event = WebhookEvent.find(webhook_event_id)
    return if event.processed?

    event.processing!

    begin
      handler = Shopify::WebhookHandler.new(event.payload, event.topic, event.tenant)
      handler.process
      event.processed!
    rescue => e
      event.update!(status: :failed, error_message: e.message)
      # Ideally, retry logic or manual intervention queue
      raise e # Let Sidekiq retry
    end
  end
end
