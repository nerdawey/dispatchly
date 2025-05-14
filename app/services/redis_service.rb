class RedisService
  class << self
    def cache_vehicle_location(vehicle_id, location)
      REDIS_POOL.with do |redis|
        redis.hset(
          RedisNamespaces::VEHICLE_LOCATIONS,
          vehicle_id,
          { latitude: location.latitude, longitude: location.longitude, updated_at: Time.current }.to_json
        )
      end
    end

    def get_vehicle_location(vehicle_id)
      REDIS_POOL.with do |redis|
        data = redis.hget(RedisNamespaces::VEHICLE_LOCATIONS, vehicle_id)
        data ? JSON.parse(data) : nil
      end
    end

    def cache_order_cluster(orders)
      REDIS_POOL.with do |redis|
        orders.each do |order|
          redis.setex(
            "#{RedisNamespaces::ORDER_CACHE}:#{order.id}",
            1.hour.to_i,
            order.attributes.to_json
          )
        end
      end
    end

    def get_cached_order(order_id)
      REDIS_POOL.with do |redis|
        data = redis.get("#{RedisNamespaces::ORDER_CACHE}:#{order_id}")
        data ? JSON.parse(data) : nil
      end
    end

    def track_dispatch_attempt(dispatch_id, attempt_data)
      REDIS_POOL.with do |redis|
        redis.hset(
          RedisNamespaces::DISPATCH_ATTEMPTS,
          dispatch_id,
          attempt_data.to_json
        )
        redis.expire(RedisNamespaces::DISPATCH_ATTEMPTS, 24.hours.to_i)
      end
    end

    def get_dispatch_attempts(dispatch_id)
      REDIS_POOL.with do |redis|
        data = redis.hget(RedisNamespaces::DISPATCH_ATTEMPTS, dispatch_id)
        data ? JSON.parse(data) : nil
      end
    end

    def rate_limit?(key, limit: 100, period: 1.hour)
      REDIS_POOL.with do |redis|
        current = redis.incr("#{RedisNamespaces::RATE_LIMITS}:#{key}")
        redis.expire("#{RedisNamespaces::RATE_LIMITS}:#{key}", period.to_i) if current == 1
        current > limit
      end
    end

    def track_active_trip(trip_id, trip_data)
      REDIS_POOL.with do |redis|
        redis.hset(
          RedisNamespaces::ACTIVE_TRIPS,
          trip_id,
          trip_data.to_json
        )
      end
    end

    def get_active_trip(trip_id)
      REDIS_POOL.with do |redis|
        data = redis.hget(RedisNamespaces::ACTIVE_TRIPS, trip_id)
        data ? JSON.parse(data) : nil
      end
    end

    def remove_active_trip(trip_id)
      REDIS_POOL.with do |redis|
        redis.hdel(RedisNamespaces::ACTIVE_TRIPS, trip_id)
      end
    end

    def clear_cache
      REDIS_POOL.with do |redis|
        redis.flushdb
      end
    end
  end
end 