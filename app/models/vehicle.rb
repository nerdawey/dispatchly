# app/models/vehicle.rb
class Vehicle < ApplicationRecord
  belongs_to :organization
  belongs_to :current_location, class_name: "Location"
  has_many :trips

  validates :name, presence: true
  validates :plate_number, presence: true
  validates :capacity_volume, presence: true
  validates :capacity_weight, presence: true
  validates :min_temp, presence: true
  validates :max_temp, presence: true
  validates :status, presence: true
  validates :cost_per_km, presence: true

  def capacity
    [ capacity_volume, capacity_weight ].min
  end
end
