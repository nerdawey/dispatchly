class TripStatusUpdateJob
  include Sidekiq::Job

  def perform
    # Get all active trips from Redis
    active_trips = get_active_trips

    active_trips.each do |trip_id, trip_data|
      process_trip_status(trip_id, trip_data)
    end
  end

  private

  def get_active_trips
    REDIS_POOL.with do |redis|
      trips = redis.hgetall(RedisNamespaces::ACTIVE_TRIPS)
      trips.transform_values { |data| JSON.parse(data) }
    end
  end

  def process_trip_status(trip_id, trip_data)
    trip = Trip.find_by(id: trip_id)
    return unless trip

    # Get current vehicle location
    vehicle_location = RedisService.get_vehicle_location(trip.vehicle_id)
    return unless vehicle_location

    # Check if trip is completed
    if trip_completed?(trip, vehicle_location)
      complete_trip(trip)
    else
      update_trip_progress(trip, vehicle_location)
    end
  end

  def trip_completed?(trip, vehicle_location)
    # Check if all orders in the trip are delivered
    trip.orders.all? do |order|
      distance_to_dropoff = Geocoder::Calculations.distance_between(
        [ vehicle_location["latitude"], vehicle_location["longitude"] ],
        [ order.dropoff_location.latitude, order.dropoff_location.longitude ]
      )

      # Consider order delivered if within 100 meters of dropoff
      distance_to_dropoff <= 0.1
    end
  end

  def complete_trip(trip)
    # Update trip status
    trip.update!(
      status: "completed",
      completed_at: Time.current
    )

    # Update order statuses
    trip.orders.each do |order|
      order.update!(
        status: "delivered",
        delivered_at: Time.current
      )
    end

    # Remove from active trips in Redis
    RedisService.remove_active_trip(trip.id)

    # Notify about completion
    NotificationService.new.notify_trip_completion(trip)
  end

  def update_trip_progress(trip, vehicle_location)
    # Update trip progress in Redis
    RedisService.track_active_trip(trip.id, {
      vehicle_id: trip.vehicle_id,
      order_ids: trip.orders.map(&:id),
      status: "in_progress",
      current_location: vehicle_location,
      updated_at: Time.current
    })
  end
end
