# app/models/trip.rb
class Trip < ApplicationRecord
  belongs_to :vehicle
  has_many :orders

  def can_include_order?(order)
    same_temp = orders.all? { |o| o.product.storage_temperature == order.product.storage_temperature }
    enough_space = remaining_capacity >= order.quantity
    same_temp && enough_space && pickup_near?(order) && dropoff_near?(order) && deadline_ok?(order)
  end

  def remaining_capacity
    vehicle.capacity - orders.sum(&:quantity)
  end
end
