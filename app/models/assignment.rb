class Assignment < ApplicationRecord
  belongs_to :trip
  belongs_to :vehicle

  validates :trip_id, presence: true
  validates :vehicle_id, presence: true
end
