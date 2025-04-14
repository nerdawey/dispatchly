# app/services/vehicle_assignment_service.rb
class VehicleAssignmentService
    def initialize(vehicles, clustered_orders)
      @vehicles = vehicles
      @clustered_orders = clustered_orders
    end

    def assign
      assignments = []

      clustered_orders.each do |_, orders|
        suitable_vehicle = vehicles.find { |v| v.capacity >= orders.sum(&:quantity) }

        if suitable_vehicle
          assignments << { vehicle: suitable_vehicle, orders: orders }
          vehicles.delete(suitable_vehicle)
        end
      end

      assignments
    end

    private

    attr_reader :vehicles, :clustered_orders
end
