class ReportsController < ApplicationController
  require 'csv'

  def index
    respond_to do |format|
      format.html
      format.csv do
        send_data generate_csv, filename: "reports-#{Date.today}.csv"
      end
    end
  end

  private

  def generate_csv
    CSV.generate(headers: true) do |csv|
      csv << ["Date", "Orders", "Revenue"]
      
      orders_data = current_tenant.orders.group_by_day(:placed_at).count
      revenue_data = current_tenant.orders.group_by_day(:placed_at).sum(:total_price_cents)
      
      orders_data.keys.each do |date|
        csv << [
          date, 
          orders_data[date], 
          (revenue_data[date] || 0) / 100.0
        ]
      end
    end
  end
end
