# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

# Create sample tenant
tenant = Tenant.create!(
  name: "Demo Store",
  email: "demo@example.com",
  password: "password123",
  password_confirmation: "password123",
  shopify_domain: "demo-store.myshopify.com",
  shopify_access_token: "shpat_demo_token_12345"
)

puts "Created tenant: #{tenant.email}"

# Create sample customers
5.times do |i|
  customer = tenant.customers.create!(
    shopify_id: "customer_#{i + 1}",
    email: "customer#{i + 1}@example.com",
    first_name: "Customer",
    last_name: "#{i + 1}",
    total_spent_cents: rand(1000..10000)
  )
  puts "Created customer: #{customer.email}"
end

# Create sample products
10.times do |i|
  product = tenant.products.create!(
    shopify_id: "product_#{i + 1}",
    title: "Product #{i + 1}",
    sku: "SKU-#{i + 1}",
    price_cents: rand(1000..5000)
  )
  puts "Created product: #{product.title}"
end

# Create sample orders
20.times do |i|
  order = tenant.orders.create!(
    shopify_id: "order_#{i + 1}",
    customer: tenant.customers.sample,
    total_price_cents: rand(1000..10000),
    currency: "USD",
    placed_at: rand(30.days.ago..Time.current)
  )
  puts "Created order: #{order.shopify_id}"
end

# Create sample custom events
15.times do |i|
  event = tenant.custom_events.create!(
    customer: tenant.customers.sample,
    event_type: ["page_view", "add_to_cart", "checkout_started"].sample,
    occurred_at: rand(30.days.ago..Time.current)
  )
  puts "Created event: #{event.event_type}"
end

puts "\nSeeding completed!"
puts "Login with: demo@example.com / password123"
