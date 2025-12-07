class DashboardController < ApplicationController
  def index
    # Get date range from params or default to last 30 days
    begin
      @start_date = params[:start_date].present? ? Date.parse(params[:start_date]) : 30.days.ago
      @end_date = params[:end_date].present? ? Date.parse(params[:end_date]) : Date.current
    rescue Date::Error, ArgumentError
      flash.now[:alert] = "Invalid date format. Using default date range."
      @start_date = 30.days.ago
      @end_date = Date.current
    end

    # Initialize analytics service
    @analytics = AnalyticsService.new(current_tenant, start_date: @start_date, end_date: @end_date)

    # Get dashboard stats
    @stats = @analytics.dashboard_stats

    # Recent orders for table
    @recent_orders = @analytics.recent_orders(limit: 10)

    # Check if Shopify is connected
    @shopify_connected = current_tenant.shopify_connected?
  end
end
