Sidekiq.configure_server do |config|
  config.redis = { url: ENV.fetch("REDIS_URL", "redis://localhost:6379/0") }
end

Sidekiq.configure_client do |config|
  config.redis = { url: ENV.fetch("REDIS_URL", "redis://localhost:6379/0") }
end

# Schedule background jobs
if Sidekiq.server?
  schedule_file = "config/sidekiq_schedule.yml"

  if File.exist?(schedule_file)
    require 'sidekiq-scheduler'
    Sidekiq.schedule = YAML.load_file(schedule_file)
    SidekiqScheduler::Scheduler.instance.reload_schedule!
  end
end
