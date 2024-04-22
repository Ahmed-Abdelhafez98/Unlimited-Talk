require 'sidekiq'
require 'sidekiq-cron'

Sidekiq.configure_client do |config|
  config.redis = { url: 'redis://redis:6379/0' }
end

Sidekiq.configure_server do |config|
  config.redis = { url: 'redis://redis:6379/0' }

  # Load the schedule from config/schedule.yml only if it exists and the current process is a Sidekiq server
  schedule_file = "config/schedule.yml"
  if File.exist?(schedule_file)
    Sidekiq::Cron::Job.load_from_hash YAML.load_file(schedule_file)
  end
end
