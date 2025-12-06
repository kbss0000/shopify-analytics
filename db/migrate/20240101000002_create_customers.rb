class CreateCustomers < ActiveRecord::Migration[7.0]
  def change
    create_table :customers do |t|
      t.references :tenant, null: false, foreign_key: true
      t.string :shopify_id, null: false
      t.string :email
      t.string :first_name
      t.string :last_name
      t.integer :total_spent_cents, default: 0, null: false

      t.timestamps
    end

    add_index :customers, [:tenant_id, :shopify_id], unique: true
    add_index :customers, :email
  end
end
