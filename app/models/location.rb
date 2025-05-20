class Location < ApplicationRecord
  belongs_to :organization
  
  geocoded_by :address
  after_validation :geocode

  has_many :pickup_orders, class_name: "Order", foreign_key: "pickup_location_id"
  has_many :dropoff_orders, class_name: "Order", foreign_key: "delivery_location_id"

  validates :name, presence: true
  validates :address, presence: true
  validates :latitude, presence: true
  validates :longitude, presence: true
  validates :organization_id, presence: true
end