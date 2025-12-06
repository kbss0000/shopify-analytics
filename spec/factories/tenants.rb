FactoryBot.define do
  factory :tenant do
    sequence(:name) { |n| "Store #{n}" }
    sequence(:email) { |n| "store#{n}@example.com" }
    password { "password123" }
    password_confirmation { "password123" }
    shopify_domain { "test-store.myshopify.com" }
    shopify_access_token { "shpat_test_token" }

    trait :without_shopify do
      shopify_domain { nil }
      shopify_access_token { nil }
    end
  end
end
