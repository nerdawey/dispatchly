# app/models/vehicle.rb
class Vehicle < ApplicationRecord
  belongs_to :organization
  belongs_to :current_location, class_name: "Location"
  has_many :trips

  validates :name, presence: true
  validates :capacity_volume, presence: true
  validates :capacity_weight, presence: true
  validates :organization_id, presence: true
  validates :current_location_id, presence: true

  def capacity
    [capacity_volume, capacity_weight].min
  end
end
