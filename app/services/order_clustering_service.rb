# app/services/order_clustering_service.rb
class OrderClusteringService
  EARTH_RADIUS_KM = 6371.0

    def initialize(orders, precision: 5)
      @orders = orders
      @precision = precision
    end

    def cluster_orders
    clusters = []

    orders.each do |order|
      added = false
      order_pickup = order.pickup_location
      order_dropoff = order.delivery_location
      order_temp = order.products.first&.storage_temperature

      clusters.each do |cluster|
        # Check pickup and dropoff proximity for all orders in the cluster
        pickup_close = cluster.all? { |o| distance_km(order_pickup, o.pickup_location) <= 5 }
        dropoff_close = cluster.all? { |o| distance_km(order_dropoff, o.delivery_location) <= 5 }
        same_temp = cluster.all? { |o| compatible_storage?(order, o) }
        if pickup_close && dropoff_close && same_temp
          cluster << order
          added = true
          break
        end
      end

      clusters << [order] unless added
    end

    # Return as a hash for compatibility
    Hash[clusters.each_with_index.map { |c, i| ["cluster_#{i+1}".to_sym, c] }]
    end

    private

    attr_reader :orders, :precision

  def distance_km(loc1, loc2)
    return Float::INFINITY unless loc1&.latitude && loc1&.longitude && loc2&.latitude && loc2&.longitude
    lat1 = loc1.latitude.to_f * Math::PI / 180
    lon1 = loc1.longitude.to_f * Math::PI / 180
    lat2 = loc2.latitude.to_f * Math::PI / 180
    lon2 = loc2.longitude.to_f * Math::PI / 180
    dlat = lat2 - lat1
    dlon = lon2 - lon1
    a = Math.sin(dlat/2)**2 + Math.cos(lat1) * Math.cos(lat2) * Math.sin(dlon/2)**2
    c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a))
    (EARTH_RADIUS_KM * c).abs
    end

  def compatible_storage?(order1, order2)
    # All products in both orders must have the same storage_temperature
    temps1 = order1.products.map(&:storage_temperature).uniq
    temps2 = order2.products.map(&:storage_temperature).uniq
    (temps1 + temps2).uniq.size == 1
    end
end
