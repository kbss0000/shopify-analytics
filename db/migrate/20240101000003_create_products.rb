class CreateProducts < ActiveRecord::Migration[7.0]
  def change
    create_table :products do |t|
      t.references :tenant, null: false, foreign_key: true
      t.string :shopify_id, null: false
      t.string :title, null: false
      t.string :sku
      t.integer :price_cents, default: 0, null: false

      t.timestamps
    end

    add_index :products, [:tenant_id, :shopify_id], unique: true
  end
end
