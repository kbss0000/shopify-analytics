class CreateWebhookEvents < ActiveRecord::Migration[7.0]
  def change
    create_table :webhook_events do |t|
      t.references :tenant, null: false, foreign_key: true
      t.string :shopify_webhook_id, null: false
      t.string :topic, null: false
      t.jsonb :payload, null: false
      t.integer :status, default: 0
      t.text :error_message

      t.timestamps
    end
    
    add_index :webhook_events, [:tenant_id, :status]
    add_index :webhook_events, :shopify_webhook_id
  end
end
