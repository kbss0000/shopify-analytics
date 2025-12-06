FactoryBot.define do
  factory :order do
    tenant
    customer
    sequence(:shopify_id) { |n| "order_#{n}" }
    total_price_cents { 5000 }
    currency { "USD" }
    placed_at { Time.current }
  end
end
