class Location < ApplicationRecord
  belongs_to :organization
  
  geocoded_by :address
  after_validation :geocode, if: :should_geocode?

  has_many :pickup_orders, class_name: "Order", foreign_key: "pickup_location_id"
  has_many :dropoff_orders, class_name: "Order", foreign_key: "delivery_location_id"

  validates :name, presence: true
  validates :address, presence: true

  private

  def should_geocode?
    address.present? && (latitude.blank? || longitude.blank?)
  end
end