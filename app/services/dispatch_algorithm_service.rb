# app/services/dispatch_algorithm_service.rb
class DispatchAlgorithmService
  def initialize(dispatch_plan_id)
    @dispatch_plan = DispatchPlan.find(dispatch_plan_id)
    @organization = @dispatch_plan.organization
    @orders = Order.where(organization: @organization, 
                          status: 'pending', 
                          delivery_deadline: @dispatch_plan.scheduled_date.beginning_of_day..@dispatch_plan.scheduled_date.end_of_day)
    @vehicles = Vehicle.where(organization: @organization, status: 'available')
    @assignments = []
  end
  
  def optimize
    # Group orders by temperature requirements
    temperature_groups = group_by_temperature(@orders)
    
    # Process each temperature group
    temperature_groups.each do |temp, orders|
      # Create geographic clusters for this temperature group
      geo_clusters = cluster_by_geography(orders)
      
      # Process each geographic cluster
      geo_clusters.each do |cluster|
        # Find compatible vehicles
        compatible_vehicles = find_compatible_vehicles(temp, cluster)
        
        if compatible_vehicles.any?
          # Create assignments
          assign_orders_to_vehicles(cluster, compatible_vehicles)
        else
          # Handle case when no compatible vehicle is found
          mark_orders_as_unassignable(cluster)
        end
      end
    end
    
    # Update dispatch plan status
    @dispatch_plan.update(status: 'optimized')
    
    # Return assignments
    @assignments
  end
  
  private
  
  def group_by_temperature(orders)
    # Group orders by the temperature requirements of their products
    groups = {}
    
    orders.each do |order|
      # Get unique temperature requirements for this order
      temps = order.order_items.joins(:product).pluck('DISTINCT products.required_temperature')
      
      # For simplicity, use the first temperature requirement
      # In a real implementation, you might handle multiple temperature requirements differently
      temp = temps.first || 0
      
      groups[temp] ||= []
      groups[temp] << order
    end
    
    groups
  end
  
  def cluster_by_geography(orders)
    # Simple implementation - can be enhanced with more sophisticated clustering
    clusters = []
    remaining = orders.to_a
    
    until remaining.empty?
      seed = remaining.shift
      cluster = [seed]
      
      remaining.each_with_index do |order, index|
        if seed.delivery_location.distance_to(order.delivery_location) < 10 # 10km radius
          cluster << order
          remaining[index] = nil
        end
      end
      
      remaining.compact!
      clusters << cluster
    end
    
    clusters
  end
  
  def find_compatible_vehicles(temperature, cluster)
    # Calculate total volume and weight for the cluster
    total_volume = 0
    total_weight = 0
    
    cluster.each do |order|
      order.order_items.each do |item|
        total_volume += item.product.volume * item.quantity
        total_weight += item.product.weight * item.quantity
      end
    end
    
    # Find vehicles that can handle this temperature and capacity
    @vehicles.select do |vehicle|
      vehicle.min_temp <= temperature && 
      vehicle.max_temp >= temperature &&
      vehicle.capacity_volume >= total_volume &&
      vehicle.capacity_weight >= total_weight
    end
  end
  
  def assign_orders_to_vehicles(cluster, vehicles)
    # Select the most cost-effective vehicle that can handle the cluster
    vehicle = vehicles.min_by(&:cost_per_km)
    
    # Create a new assignment
    assignment = Assignment.create!(
      dispatch_plan: @dispatch_plan,
      vehicle: vehicle,
      status: 'planned',
      estimated_start_time: @dispatch_plan.scheduled_date.beginning_of_day + 8.hours,
      estimated_completion_time: calculate_estimated_completion_time(cluster, vehicle),
      total_distance: calculate_total_distance(cluster, vehicle)
    )
    
    # Associate orders with this assignment
    cluster.each do |order|
      order.update(assignment: assignment, status: 'assigned')
    end
    
    # Track created assignments
    @assignments << assignment
  end
  
  def mark_orders_as_unassignable(cluster)
    cluster.each do |order|
      order.update(status: 'unassignable')
    end
  end
  
  def calculate_estimated_completion_time(cluster, vehicle)
    # Simple estimation - can be enhanced with more sophisticated routing
    # Assume average speed of 40 km/h and 15 minutes per stop
    total_distance = calculate_total_distance(cluster, vehicle)
    travel_time_hours = total_distance / 40
    
    # Each order is a stop
    handling_time_hours = cluster.size * 15 / 60.0
    
    # Start time + travel time + handling time
    @dispatch_plan.scheduled_date.beginning_of_day + 8.hours + (travel_time_hours + handling_time_hours).hours
  end
  
  def calculate_total_distance(cluster, vehicle)
    total_distance = 0
    
    # Assume vehicle starts at its current location
    current_point = vehicle.current_location
    
    # First, calculate distance to all pickup locations
    pickup_locations = cluster.map(&:pickup_location).uniq
    
    pickup_locations.each do |location|
      total_distance += current_point.distance_to(location)
      current_point = location
    end
    
    # Then calculate distances between all delivery locations
    delivery_locations = cluster.map(&:delivery_location)
    
    delivery_locations.each do |location|
      total_distance += current_point.distance_to(location)
      current_point = location
    end
    
    total_distance
  end
end