require "sidekiq"
require "sidekiq-scheduler"

Sidekiq.configure_server do |config|
  config.redis = REDIS_CONFIG.merge(namespace: "dispatchly:sidekiq")

  # Load scheduled jobs
  config.on(:startup) do
    Sidekiq.schedule = {
      "vehicle_location_updater" => {
        "cron" => "*/5 * * * *", # Every 5 minutes
        "class" => "VehicleLocationUpdateJob"
      },
      "dispatch_retry_processor" => {
        "cron" => "*/15 * * * *", # Every 15 minutes
        "class" => "DispatchRetryProcessorJob"
      },
      "trip_status_updater" => {
        "cron" => "*/1 * * * *", # Every minute
        "class" => "TripStatusUpdateJob"
      }
    }
    SidekiqScheduler::Scheduler.instance.reload_schedule!
  end
end

Sidekiq.configure_client do |config|
  config.redis = REDIS_CONFIG.merge(namespace: "dispatchly:sidekiq")
end

# Configure Sidekiq middleware
Sidekiq.configure_server do |config|
  config.server_middleware do |chain|
    chain.add Sidekiq::Middleware::Server::RetryJobs, max_retries: 3
    chain.add Sidekiq::Middleware::Server::Logging
  end
end
