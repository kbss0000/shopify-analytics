FactoryBot.define do
  factory :product do
    tenant
    sequence(:shopify_id) { |n| "product_#{n}" }
    sequence(:title) { |n| "Product #{n}" }
    sequence(:sku) { |n| "SKU-#{n}" }
    price_cents { 2500 }
  end
end
