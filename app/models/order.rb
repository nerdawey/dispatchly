class Order < ApplicationRecord
  enum :order_type, { outbound: 0, inbound: 1 }

  belongs_to :organization
  belongs_to :pickup_location, class_name: "Location"
  belongs_to :delivery_location, class_name: "Location"
  has_many :order_items, dependent: :destroy
  has_many :products, through: :order_items
  belongs_to :trip, optional: true

  validates :order_number, presence: true
  validates :pickup_time_window_start, presence: true
  validates :pickup_time_window_end, presence: true
  validates :delivery_deadline, presence: true
  validates :status, presence: true
  validates :order_type, presence: true

  def quantity
    order_items.sum(&:quantity)
  end
end
