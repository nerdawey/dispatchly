# app/services/order_clustering_service.rb
class OrderClusteringService
    def initialize(orders, precision: 5)
      @orders = orders
      @precision = precision
    end

    def cluster_orders
      orders.group_by do |order|
        [
          order.product.storage_temperature,
          geo_hash(order.pickup_location),
          geo_hash(order.dropoff_location),
          time_window_hash(order.deadline)
        ]
      end
    end

    private

    attr_reader :orders, :precision

    def geo_hash(location)
      Geocoder::Calculations.geohash(
        location.latitude,
        location.longitude,
        precision: precision
      )
    end

    def time_window_hash(deadline)
      # Group orders into 30-minute time windows
      deadline.beginning_of_hour + ((deadline.min / 30) * 30).minutes
    end
end
