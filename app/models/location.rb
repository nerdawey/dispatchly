class Location < ApplicationRecord
  belongs_to :organization, optional: true
  
  geocoded_by :address
  after_validation :geocode, if: :should_geocode?

  has_many :pickup_orders, class_name: "Order", foreign_key: "pickup_location_id", dependent: :destroy, inverse_of: :pickup_location
  has_many :dropoff_orders, class_name: "Order", foreign_key: "delivery_location_id", dependent: :destroy, inverse_of: :delivery_location
  has_many :vehicles, foreign_key: :current_location_id, dependent: :nullify, inverse_of: :current_location
  has_many :orders, foreign_key: :delivery_location_id, dependent: :nullify, inverse_of: :delivery_location
  has_many :trips, foreign_key: :end_location_id, dependent: :nullify, inverse_of: :end_location

  validates :name, presence: true
  validates :address, presence: true
  validates :latitude, presence: true, numericality: true
  validates :longitude, presence: true, numericality: true
  validates :location_type, presence: true, inclusion: { in: %w[warehouse market] }
  validates :city, presence: true

  before_destroy :nullify_vehicle_locations

  private

  def should_geocode?
    address.present? && (latitude.blank? || longitude.blank?)
  end

  def nullify_vehicle_locations
    vehicles.each { |vehicle| vehicle.update(current_location_id: nil) }
  end
end