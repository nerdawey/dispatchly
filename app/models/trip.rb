# app/models/trip.rb
class Trip < ApplicationRecord
  belongs_to :vehicle
  belongs_to :organization
  has_many :orders

  validates :name, presence: true
  validates :status, presence: true
  validates :scheduled_date, presence: true
  validates :vehicle_id, presence: true
  validates :organization_id, presence: true
  validates :start_time, presence: true
  validates :end_time, presence: true

  def can_include_order?(order)
    same_temp = orders.all? { |o| o.product.storage_temperature == order.product.storage_temperature }
    enough_space = remaining_capacity >= order.quantity
    same_temp && enough_space && pickup_near?(order) && dropoff_near?(order) && deadline_ok?(order)
  end

  def remaining_capacity
    vehicle.capacity - orders.sum(&:quantity)
  end
end
