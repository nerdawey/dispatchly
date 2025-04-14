# app/services/order_clustering_service.rb
class OrderClusteringService
    def initialize(orders)
      @orders = orders
    end

    def cluster_orders
      orders.group_by do |order|
        [
          order.product.storage_temperature,
          geo_hash(order.pickup_location),
          geo_hash(order.dropoff_location)
        ]
      end
    end

    private

    attr_reader :orders

    def geo_hash(location)
      Geocoder::Calculations.geohash(location.latitude, location.longitude, precision: 5)
    end
end
