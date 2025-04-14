class Order < ApplicationRecord
  belongs_to :product
  belongs_to :pickup_location, class_name: "Location"
  belongs_to :dropoff_location, class_name: "Location"
  belongs_to :warehouse
  belongs_to :trip, optional: true

  validates :quantity, :deadline, presence: true
end
