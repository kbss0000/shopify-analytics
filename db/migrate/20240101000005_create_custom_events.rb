class CreateCustomEvents < ActiveRecord::Migration[7.0]
  def change
    create_table :custom_events do |t|
      t.references :tenant, null: false, foreign_key: true
      t.references :customer, null: true, foreign_key: true
      t.string :event_type, null: false
      t.datetime :occurred_at, null: false

      t.timestamps
    end

    add_index :custom_events, :event_type
    add_index :custom_events, :occurred_at
  end
end
