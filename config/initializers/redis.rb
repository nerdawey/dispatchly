require 'redis'

REDIS_CONFIG = {
  url: ENV.fetch('REDIS_URL', 'redis://localhost:6379/1'),
  ssl_params: { verify_mode: OpenSSL::SSL::VERIFY_NONE },
  timeout: 1,
  reconnect_attempts: 2
}

REDIS = Redis.new(REDIS_CONFIG)

# Define Redis namespaces
module RedisNamespaces
  VEHICLE_LOCATIONS = 'vehicle_locations'
  ORDER_CACHE = 'order_cache'
  DISPATCH_ATTEMPTS = 'dispatch_attempts'
  RATE_LIMITS = 'rate_limits'
  ACTIVE_TRIPS = 'active_trips'
end

# Configure Redis connection pool
REDIS_POOL = ConnectionPool.new(size: 5, timeout: 5) do
  Redis.new(REDIS_CONFIG)
end 