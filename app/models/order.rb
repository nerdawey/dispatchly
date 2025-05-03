class Order < ApplicationRecord
  enum order_type: { outbound: 0, inbound: 1 }

  belongs_to :product
  belongs_to :pickup_location, class_name: "Location", optional: true
  belongs_to :dropoff_location, class_name: "Location", optional: true
  belongs_to :warehouse
  belongs_to :trip, optional: true

  validates :quantity, :deadline, presence: true
end
