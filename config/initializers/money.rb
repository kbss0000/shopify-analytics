# config/initializers/money.rb
Money.locale_backend = :i18n

MoneyRails.configure do |config|
  config.default_currency = :usd
  
  # Add exchange rates for demo
  config.add_rate "USD", "INR", 83.50
  config.add_rate "INR", "USD", 0.012
end