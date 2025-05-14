# app/services/vehicle_assignment_service.rb
class VehicleAssignmentService
    def initialize(vehicles, clustered_orders)
      @vehicles = vehicles.dup # Create a copy to avoid modifying the original
      @clustered_orders = clustered_orders
      @unassigned_orders = []
    end

    def assign
      assignments = []

      clustered_orders.each do |_, orders|
        suitable_vehicle = find_suitable_vehicle(orders)

        if suitable_vehicle
          assignments << { vehicle: suitable_vehicle, orders: orders }
          vehicles.delete(suitable_vehicle)

          # Cache vehicle location
          RedisService.cache_vehicle_location(
            suitable_vehicle.id,
            suitable_vehicle.current_location
          )
        else
          # Store unassigned orders for potential re-clustering
          @unassigned_orders.concat(orders)
        end
      end

      # Return both assignments and unassigned orders
      {
        assignments: assignments,
        unassigned_orders: @unassigned_orders
      }
    end

    private

    attr_reader :vehicles, :clustered_orders, :unassigned_orders

    def find_suitable_vehicle(orders)
      total_quantity = orders.sum(&:quantity)
      required_temperature = orders.first.product.storage_temperature

      vehicles.find do |vehicle|
        vehicle.available? &&
        vehicle.capacity >= total_quantity &&
        vehicle.temperature_range.include?(required_temperature) &&
        vehicle_can_handle_time_window?(vehicle, orders)
      end
    end

    def vehicle_can_handle_time_window?(vehicle, orders)
      # Check if vehicle can complete all orders within their time windows
      orders.all? do |order|
        estimated_delivery_time = calculate_estimated_delivery_time(vehicle, order)
        estimated_delivery_time <= order.deadline
      end
    end

    def calculate_estimated_delivery_time(vehicle, order)
      # Get vehicle location from Redis cache
      vehicle_location = RedisService.get_vehicle_location(vehicle.id)

      if vehicle_location
        current_location = OpenStruct.new(
          latitude: vehicle_location["latitude"],
          longitude: vehicle_location["longitude"]
        )
      else
        current_location = vehicle.current_location
        # Cache the location for future use
        RedisService.cache_vehicle_location(vehicle.id, current_location)
      end

      current_time = Time.current
      travel_time = calculate_travel_time(current_location, order.pickup_location)
      pickup_time = current_time + travel_time
      delivery_time = pickup_time + calculate_travel_time(order.pickup_location, order.dropoff_location)

      delivery_time
    end

    def calculate_travel_time(from, to)
      # Basic implementation - should be replaced with actual routing service
      distance = Geocoder::Calculations.distance_between(
        [ from.latitude, from.longitude ],
        [ to.latitude, to.longitude ]
      )

      # Assume average speed of 30 km/h
      (distance / 30.0) * 3600 # Convert to seconds
    end
end
