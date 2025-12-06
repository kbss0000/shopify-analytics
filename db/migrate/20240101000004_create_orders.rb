class CreateOrders < ActiveRecord::Migration[7.0]
  def change
    create_table :orders do |t|
      t.references :tenant, null: false, foreign_key: true
      t.references :customer, null: true, foreign_key: true
      t.string :shopify_id, null: false
      t.integer :total_price_cents, default: 0, null: false
      t.string :currency, default: "USD", null: false
      t.datetime :placed_at, null: false

      t.timestamps
    end

    add_index :orders, [:tenant_id, :shopify_id], unique: true
    add_index :orders, :placed_at
  end
end
