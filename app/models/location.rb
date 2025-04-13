# app/models/location.rb
class Location < ApplicationRecord
  belongs_to :organization
  
  has_many :vehicles, foreign_key: 'current_location_id', dependent: :nullify
  has_many :pickup_orders, class_name: 'Order', foreign_key: 'pickup_location_id', dependent: :nullify
  has_many :delivery_orders, class_name: 'Order', foreign_key: 'delivery_location_id', dependent: :nullify
  
  validates :name, :address, presence: true
  validates :latitude, :longitude, presence: true, numericality: true
  
  def distance_to(other_location)
    # Haversine formula for calculating distance between coordinates
    radius = 6371 # Earth's radius in km
    
    lat1 = self.latitude.to_f * Math::PI / 180
    lon1 = self.longitude.to_f * Math::PI / 180
    lat2 = other_location.latitude.to_f * Math::PI / 180
    lon2 = other_location.longitude.to_f * Math::PI / 180
    
    dlon = lon2 - lon1
    dlat = lat2 - lat1
    
    a = Math.sin(dlat/2)**2 + Math.cos(lat1) * Math.cos(lat2) * Math.sin(dlon/2)**2
    c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a))
    
    radius * c # distance in km
  end
end