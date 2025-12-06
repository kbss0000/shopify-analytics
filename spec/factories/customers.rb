FactoryBot.define do
  factory :customer do
    tenant
    sequence(:shopify_id) { |n| "customer_#{n}" }
    sequence(:email) { |n| "customer#{n}@example.com" }
    first_name { "John" }
    last_name { "Doe" }
    total_spent_cents { 10000 }
  end
end
