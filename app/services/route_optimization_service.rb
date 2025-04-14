# app/services/route_optimization_service.rb
class RouteOptimizationService
    def initialize(orders)
      @orders = orders
    end

    def optimize
      return orders if orders.size <= 1

      orders.sort_by do |order|
        [ order.deadline, order.dropoff_location.latitude, order.dropoff_location.longitude ]
      end
    end

    private

    attr_reader :orders
end
