# app/services/dispatch_algorithm_service.rb
class DispatchAlgorithmService
    def initialize(orders, vehicles)
      @orders = orders
      @vehicles = vehicles
    end
  
    def call
      clustered_orders = OrderClusteringService.new(orders).cluster_orders
      assignments = VehicleAssignmentService.new(vehicles, clustered_orders).assign
  
      assignments.each do |assignment|
        optimized_orders = RouteOptimizationService.new(assignment[:orders]).optimize
        create_trip(assignment[:vehicle], optimized_orders)
      end
    end
  
    private
  
    attr_reader :orders, :vehicles
  
    def create_trip(vehicle, orders)
      trip = Trip.create!(vehicle: vehicle)
      orders.each { |order| order.update!(trip: trip) }
    end
end
  