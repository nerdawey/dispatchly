class Vehicle < ApplicationRecord
  belongs_to :organization
  belongs_to :current_location
end
