class Location < ApplicationRecord
  geocoded_by :address
  after_validation :geocode

  has_many :pickup_orders, class_name: "Order", foreign_key: "pickup_location_id"
  has_many :dropoff_orders, class_name: "Order", foreign_key: "dropoff_location_id"
end