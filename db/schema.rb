# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2025_12_06_154516) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "custom_events", force: :cascade do |t|
    t.bigint "tenant_id", null: false
    t.bigint "customer_id"
    t.string "event_type", null: false
    t.datetime "occurred_at", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["customer_id"], name: "index_custom_events_on_customer_id"
    t.index ["event_type"], name: "index_custom_events_on_event_type"
    t.index ["occurred_at"], name: "index_custom_events_on_occurred_at"
    t.index ["tenant_id"], name: "index_custom_events_on_tenant_id"
  end

  create_table "customers", force: :cascade do |t|
    t.bigint "tenant_id", null: false
    t.string "shopify_id", null: false
    t.string "email"
    t.string "first_name"
    t.string "last_name"
    t.integer "total_spent_cents", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_customers_on_email"
    t.index ["tenant_id", "email"], name: "index_customers_on_tenant_id_and_email"
    t.index ["tenant_id", "shopify_id"], name: "index_customers_on_tenant_id_and_shopify_id", unique: true
    t.index ["tenant_id", "total_spent_cents"], name: "index_customers_on_tenant_id_and_total_spent_cents"
    t.index ["tenant_id"], name: "index_customers_on_tenant_id"
  end

  create_table "orders", force: :cascade do |t|
    t.bigint "tenant_id", null: false
    t.bigint "customer_id"
    t.string "shopify_id", null: false
    t.integer "total_price_cents", default: 0, null: false
    t.string "currency", default: "USD", null: false
    t.datetime "placed_at", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "status", default: "pending"
    t.index ["customer_id"], name: "index_orders_on_customer_id"
    t.index ["placed_at"], name: "index_orders_on_placed_at"
    t.index ["tenant_id", "placed_at"], name: "index_orders_on_tenant_id_and_placed_at"
    t.index ["tenant_id", "shopify_id"], name: "index_orders_on_tenant_id_and_shopify_id", unique: true
    t.index ["tenant_id", "status"], name: "index_orders_on_tenant_id_and_status"
    t.index ["tenant_id", "total_price_cents"], name: "index_orders_on_tenant_id_and_total_price_cents"
    t.index ["tenant_id"], name: "index_orders_on_tenant_id"
  end

  create_table "products", force: :cascade do |t|
    t.bigint "tenant_id", null: false
    t.string "shopify_id", null: false
    t.string "title", null: false
    t.string "sku"
    t.integer "price_cents", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tenant_id", "shopify_id"], name: "index_products_on_tenant_id_and_shopify_id", unique: true
    t.index ["tenant_id"], name: "index_products_on_tenant_id"
  end

  create_table "tenants", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "name", null: false
    t.string "shopify_domain"
    t.string "shopify_access_token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_tenants_on_email", unique: true
    t.index ["reset_password_token"], name: "index_tenants_on_reset_password_token", unique: true
    t.index ["shopify_domain"], name: "index_tenants_on_shopify_domain", unique: true
  end

  create_table "webhook_events", force: :cascade do |t|
    t.bigint "tenant_id", null: false
    t.string "shopify_webhook_id", null: false
    t.string "topic", null: false
    t.jsonb "payload", null: false
    t.integer "status", default: 0
    t.text "error_message"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["shopify_webhook_id"], name: "index_webhook_events_on_shopify_webhook_id"
    t.index ["tenant_id", "status"], name: "index_webhook_events_on_tenant_id_and_status"
    t.index ["tenant_id"], name: "index_webhook_events_on_tenant_id"
  end

  add_foreign_key "custom_events", "customers"
  add_foreign_key "custom_events", "tenants"
  add_foreign_key "customers", "tenants"
  add_foreign_key "orders", "customers"
  add_foreign_key "orders", "tenants"
  add_foreign_key "products", "tenants"
  add_foreign_key "webhook_events", "tenants"
end
