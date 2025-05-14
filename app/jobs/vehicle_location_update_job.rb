class VehicleLocationUpdateJob
  include Sidekiq::Job

  def perform
    Vehicle.active.find_each do |vehicle|
      # Get current location from GPS or tracking system
      current_location = vehicle.fetch_current_location
      
      # Update Redis cache
      RedisService.cache_vehicle_location(vehicle.id, current_location)
      
      # Update database if needed
      vehicle.update!(
        current_latitude: current_location.latitude,
        current_longitude: current_location.longitude,
        last_location_update: Time.current
      )
    end
  rescue StandardError => e
    Rails.logger.error("Vehicle location update failed: #{e.message}")
    raise
  end
end 