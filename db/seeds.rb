# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

# Create sample tenant
tenant = Tenant.find_or_initialize_by(email: "demo@example.com")
tenant.update!(
  name: "Demo Store",
  password: "password123",
  password_confirmation: "password123",
  shopify_domain: "demo-store.myshopify.com",
  shopify_access_token: "shpat_demo_token_12345"
)

puts "Created/Updated tenant: #{tenant.email}"

# Create sample customers
5.times do |i|
  customer = tenant.customers.find_or_create_by!(shopify_id: "customer_#{i + 1}") do |c|
    c.email = "customer#{i + 1}@example.com"
    c.first_name = "Customer"
    c.last_name = "#{i + 1}"
    c.total_spent_cents = rand(1000..10000)
  end
  puts "Created/Found customer: #{customer.email}"
end

# Create sample products
10.times do |i|
  product = tenant.products.find_or_create_by!(shopify_id: "product_#{i + 1}") do |p|
    p.title = "Product #{i + 1}"
    p.sku = "SKU-#{i + 1}"
    p.price_cents = rand(1000..5000)
  end
  puts "Created/Found product: #{product.title}"
end

# Create sample orders
# Only create if we have fewer than 20 orders to avoid infinite growth
if tenant.orders.count < 20
  20.times do |i|
    tenant.orders.create!(
      shopify_id: "order_#{SecureRandom.hex(8)}",
      customer: tenant.customers.sample,
      total_price_cents: rand(1000..10000),
      currency: "USD",
      placed_at: rand(30.days.ago..Time.current)
    )
  end
  puts "Created sample orders"
end

# Create sample custom events
if tenant.custom_events.count < 15
  15.times do |i|
    tenant.custom_events.create!(
      customer: tenant.customers.sample,
      event_type: ["page_view", "add_to_cart", "checkout_started"].sample,
      occurred_at: rand(30.days.ago..Time.current)
    )
  end
  puts "Created sample events"
end

puts "\nSeeding completed!"
puts "Login with: demo@example.com / password123"
