class Order < ApplicationRecord
  belongs_to :organization
  belongs_to :pickup_location
  belongs_to :delivery_location
end
