class AnalyticsService
  attr_reader :tenant, :start_date, :end_date

  def initialize(tenant, start_date: nil, end_date: nil)
    @tenant = tenant
    @start_date = start_date || 30.days.ago
    @end_date = end_date || Time.current
  end

  def dashboard_stats
    {
      total_customers: total_customers,
      total_orders: total_orders,
      total_revenue: total_revenue,
      orders_by_date: orders_by_date,
      revenue_by_date: revenue_by_date_for_chart,
      top_customers: top_customers,
      average_order_value: average_order_value,
      total_products: total_products
    }
  end

  def total_customers
    tenant.customers.count
  end

  def total_orders
    tenant.orders.placed_between(start_date, end_date).count
  end

  def total_revenue
    revenue_cents = tenant.orders.placed_between(start_date, end_date).sum(:total_price_cents)
    Money.new(revenue_cents, 'USD')
  end

  def average_order_value
    orders = tenant.orders.placed_between(start_date, end_date)
    return Money.new(0, 'USD') if orders.empty?

    avg_cents = orders.average(:total_price_cents).to_f
    Money.new(avg_cents.round, 'USD')
  end

  def total_products
    tenant.products.count
  end

  def orders_by_date
    tenant.orders
      .placed_between(start_date, end_date)
      .group_by_day(:placed_at)
      .count
  end

  def revenue_by_date
    tenant.orders
      .placed_between(start_date, end_date)
      .group_by_day(:placed_at)
      .sum(:total_price_cents)
      .transform_values { |cents| Money.new(cents, 'USD') }
  end

  def revenue_by_date_for_chart
    data = tenant.orders
      .placed_between(start_date, end_date)
      .group_by_day(:placed_at)
      .sum(:total_price_cents)
    
    # Convert to hash format that Chartkick expects: { "2024-01-01" => 100.50, ... }
    data.transform_keys { |date| date.to_s }.transform_values { |cents| cents / 100.0 }
  end

  def top_customers(limit: 5)
    tenant.customers
      .by_total_spent
      .limit(limit)
      .select(:id, :email, :first_name, :last_name, :total_spent_cents)
  end

  def recent_orders(limit: 10)
    tenant.orders
      .includes(:customer)
      .recent
      .limit(limit)
  end

  def orders_count_by_status
    tenant.orders
      .placed_between(start_date, end_date)
      .group(:status)
      .count
      .transform_keys { |status| status.presence || 'pending' }
  end

  def customers_with_orders
    tenant.customers.joins(:orders).distinct.count
  end

  def conversion_rate
    total = tenant.customers.count
    return 0 if total.zero?

    with_orders = customers_with_orders
    ((with_orders.to_f / total) * 100).round(2)
  end
end
