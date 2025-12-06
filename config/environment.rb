# Load the Rails application.
require_relative "application"

# Optimize Rails for performance
# Use jemalloc if available for better memory management
if ENV["LD_PRELOAD"]&.include?("libjemalloc")
  puts "Using jemalloc for memory optimization"
end

# Initialize the Rails application.
Rails.application.initialize!
