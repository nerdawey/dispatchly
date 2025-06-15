# app/services/vehicle_assignment_service.rb
class VehicleAssignmentService
    def initialize(vehicles, clustered_orders)
      @vehicles = vehicles.dup # Create a copy to avoid modifying the original
      @clustered_orders = clustered_orders
      @unassigned_orders = []
      @assigned_vehicle_ids = [] # Track assigned vehicle IDs
    end

    def assign
      assignments = []

      clustered_orders.values.each do |orders|
        suitable_vehicle = find_suitable_vehicle(orders)

        if suitable_vehicle
          assignments << { vehicle: suitable_vehicle, orders: orders }
          @assigned_vehicle_ids << suitable_vehicle.id # Track the ID instead of deleting
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
      total_quantity = orders.sum { |order| order.order_items.sum(&:quantity) }
      total_weight = orders.sum(&:total_weight)
      requires_freezing = orders.any? do |order|
        order.order_items.any? { |item| item.product.storage_temperature == "frozen" }
      end

      vehicles.find do |vehicle|
        @assigned_vehicle_ids.exclude?(vehicle.id) && # Check if vehicle is already assigned
        vehicle.capacity_volume >= total_quantity &&
        vehicle.capacity_weight >= total_weight &&
        (!requires_freezing || vehicle.freezing_available)
      end
    end
end
