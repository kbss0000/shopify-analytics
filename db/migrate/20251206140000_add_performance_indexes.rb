class AddPerformanceIndexes < ActiveRecord::Migration[7.0]
  disable_ddl_transaction!

  def change
    # Orders indexes
    add_index :orders, [:tenant_id, :placed_at], algorithm: :concurrently if !index_exists?(:orders, [:tenant_id, :placed_at])
    add_index :orders, [:tenant_id, :total_price_cents], algorithm: :concurrently if !index_exists?(:orders, [:tenant_id, :total_price_cents])
    
    # Customers indexes
    add_index :customers, [:tenant_id, :total_spent_cents], algorithm: :concurrently if !index_exists?(:customers, [:tenant_id, :total_spent_cents])
    add_index :customers, [:tenant_id, :email], algorithm: :concurrently if !index_exists?(:customers, [:tenant_id, :email])
  end
end