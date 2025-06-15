# app/models/vehicle.rb
class Vehicle < ApplicationRecord
  belongs_to :organization
  has_many :trips, dependent: :destroy
  has_many :assignments, dependent: :destroy

  validates :plate_number, presence: true
  validates :capacity_volume, presence: true
  validates :capacity_weight, presence: true
  validates :status, presence: true
  validates :model, presence: true
  validates :year, presence: true
  validates :box_type, presence: true
  validates :last_maintenance_date, presence: true
  validates :freezing_available, inclusion: { in: [ true, false ] }

  # Scope to find available vehicles (not assigned to active trips and have active status)
  scope :available, -> {
    Rails.logger.info("Checking for available vehicles")
    vehicles = where(status: "active")
    Rails.logger.info("Found #{vehicles.count} active vehicles")

    # Get vehicles not assigned to active trips
    available_vehicles = vehicles.where.not(
      id: Trip.where(status: [ "in_progress", "scheduled" ]).select(:vehicle_id)
    )
    Rails.logger.info("Found #{available_vehicles.count} available vehicles")

    available_vehicles
  }

  validate :freezing_only_for_closed_box

  def freezing_only_for_closed_box
    if box_type != "closed" && freezing_available
      errors.add(:freezing_available, "can only be true if box_type is closed")
    end
  end

  def capacity
    [ capacity_volume, capacity_weight ].min
  end

  def available?
    # A vehicle is available if:
    # 1. It has an active status
    # 2. It's not currently assigned to any active trips
    status == "active" && !trips.exists?(status: [ "in_progress", "scheduled" ])
  end
end
