module ApplicationHelper
  def format_currency(money)
    return "$0.00" if money.nil?
    
    currency = session[:currency] || 'USD'
    
    if currency == 'INR'
      begin
        # Use Money gem's exchange rate if available
        inr_value = money.exchange_to("INR")
        inr_value.format(symbol: "₹")
      rescue Money::Bank::UnknownRate, NoMethodError
        # Fallback: approximate conversion (1 USD ≈ 83.5 INR from initializer)
        usd_amount = money.cents / 100.0
        inr_amount = (usd_amount * 83.5).round(2)
        "₹#{inr_amount.to_s.reverse.gsub(/(\d{3})(?=\d)/, '\\1,').reverse}"
      end
    else
      money.format(symbol: "$")
    end
  rescue => e
    # Final fallback to basic formatting
    Rails.logger.error("Currency formatting error: #{e.message}")
    "$#{money.cents / 100.0}"
  end

  def format_date(date)
    return "" if date.nil?
    date.strftime("%B %d, %Y")
  end

  def format_datetime(datetime)
    return "" if datetime.nil?
    datetime.strftime("%B %d, %Y at %I:%M %p")
  end

  def flash_class(level)
    case level.to_sym
    when :notice then "bg-[#FF9E64]/20 border-[#FF9E64] text-[#FF9E64]"
    when :success then "bg-[#BB9AF7]/20 border-[#BB9AF7] text-[#BB9AF7]"
    when :error then "bg-[#FF9E64]/20 border-[#FF9E64] text-[#FF9E64]"
    when :alert then "bg-[#FF9E64]/20 border-[#FF9E64] text-[#FF9E64]"
    else "bg-[#2F3549] border-[#414868] text-[#C0CAF5]"
    end
  end
end