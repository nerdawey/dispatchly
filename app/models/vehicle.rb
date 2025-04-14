# app/models/vehicle.rb
class Vehicle < ApplicationRecord
  belongs_to :organization
  has_many :trips

  validates :capacity, presence: true
end
