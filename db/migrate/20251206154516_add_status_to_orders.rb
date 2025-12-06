class AddStatusToOrders < ActiveRecord::Migration[7.0]
  def change
    add_column :orders, :status, :string, default: 'pending'
    add_index :orders, [:tenant_id, :status]
  end
end
