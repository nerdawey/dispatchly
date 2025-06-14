# app/services/dispatch_algorithm_service.rb
class DispatchAlgorithmService
  class DispatchError < StandardError; end
  class NoVehiclesAvailableError < DispatchError; end

  def initialize(orders, vehicles)
    @orders = orders
    @vehicles = vehicles
    @max_retries = 3
    @retry_count = 0
    @dispatch_id = SecureRandom.uuid
  end

  def call
    begin
      # Check rate limiting
      if RedisService.rate_limit?("dispatch_algorithm", limit: 1000, period: 1.hour)
        raise DispatchError, "Rate limit exceeded for dispatch algorithm"
      end

      process_dispatch
    rescue NoVehiclesAvailableError => e
      handle_no_vehicles_available
    rescue StandardError => e
      Rails.logger.error("Dispatch failed: #{e.message}")
      Rails.logger.error(e.backtrace.join("\n"))
      raise DispatchError, "Failed to process dispatch: #{e.message}"
    end
  end

  private

  attr_reader :orders, :vehicles, :max_retries, :retry_count, :dispatch_id

  def process_dispatch
    Rails.logger.info("Starting dispatch process with #{orders.size} orders and #{vehicles.size} vehicles")
    
    # Cache orders for faster access
    RedisService.cache_order_cluster(orders)

    clustered_orders = OrderClusteringService.new(orders).cluster_orders
    Rails.logger.info("Orders clustered into #{clustered_orders.size} clusters")
    
    result = VehicleAssignmentService.new(vehicles, clustered_orders).assign
    Rails.logger.info("Vehicle assignment result: #{result.inspect}")

    if result[:assignments].empty?
      raise NoVehiclesAvailableError, "No suitable vehicles available for the orders"
    end

    result[:assignments].map do |assignment|
      Rails.logger.info("Processing assignment for vehicle #{assignment[:vehicle].id} with #{assignment[:orders].size} orders")
      
      optimized_orders = RouteOptimizationService.new(assignment[:orders]).optimize
      Rails.logger.info("Orders optimized for vehicle #{assignment[:vehicle].id}")
      
      begin
        trip = create_trip(assignment[:vehicle], optimized_orders)
        Rails.logger.info("Created trip #{trip.id} for vehicle #{assignment[:vehicle].id}")
        
        # Track active trip in Redis
        RedisService.track_active_trip(trip.id, {
          vehicle_id: assignment[:vehicle].id,
          order_ids: optimized_orders.map(&:id),
          status: 'active',
          created_at: Time.current
        })

        trip
      rescue => e
        Rails.logger.error("Failed to create trip: #{e.message}")
        Rails.logger.error(e.backtrace.join("\n"))
        raise
      end
    end
  end

  def handle_no_vehicles_available
    if retry_count < max_retries
      @retry_count += 1
      Rails.logger.info("Attempting re-clustering (attempt #{retry_count}/#{max_retries})")
      
      # Track dispatch attempt
      RedisService.track_dispatch_attempt(dispatch_id, {
        attempt: retry_count,
        timestamp: Time.current,
        precision: 4 - retry_count
      })
      
      # Re-cluster with different parameters
      reclustered_orders = OrderClusteringService.new(
        orders,
        precision: 4 - retry_count # Reduce geohash precision with each retry
      ).cluster_orders
      
      # Try assignment again with reclustered orders
      result = VehicleAssignmentService.new(vehicles, reclustered_orders).assign
      
      if result[:assignments].empty?
        handle_no_vehicles_available
      else
        result[:assignments].map do |assignment|
          optimized_orders = RouteOptimizationService.new(assignment[:orders]).optimize
          trip = create_trip(assignment[:vehicle], optimized_orders)
          
          # Track active trip in Redis
          RedisService.track_active_trip(trip.id, {
            vehicle_id: assignment[:vehicle].id,
            order_ids: optimized_orders.map(&:id),
            status: 'active',
            created_at: Time.current
          })

          trip
        end
      end
    else
      handle_failed_dispatch
    end
  end

  def handle_failed_dispatch
    # Log the failed dispatch
    Rails.logger.error("Dispatch failed after #{max_retries} attempts")
    
    # Create a failed dispatch record
    failed_dispatch = FailedDispatch.create!(
      orders: orders,
      reason: "No suitable vehicles available after #{max_retries} clustering attempts",
      attempted_at: Time.current
    )
    
    # Track failed dispatch in Redis
    RedisService.track_dispatch_attempt(dispatch_id, {
      status: 'failed',
      failed_dispatch_id: failed_dispatch.id,
      timestamp: Time.current
    })
    
    # Notify relevant parties
    NotificationService.new.notify_dispatch_failure(orders)
    
    raise NoVehiclesAvailableError, "Failed to find suitable vehicles after #{max_retries} attempts"
  end

  def create_trip(vehicle, orders)
    Rails.logger.info("Creating trip for vehicle #{vehicle.id} with #{orders.size} orders")
    Rails.logger.info("Vehicle organization: #{vehicle.organization.inspect}")
    
    scheduled_date = orders.map(&:delivery_deadline).compact.min
    trip = Trip.create!(
      vehicle: vehicle,
      organization: vehicle.organization,
      status: 'assigned',
      scheduled_date: scheduled_date
    )
    
    Rails.logger.info("Created trip #{trip.id}, updating orders")
    orders.each { |order| order.update!(trip: trip) }
    
    trip
  end
end
  