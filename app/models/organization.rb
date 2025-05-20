class Organization < ApplicationRecord
  has_many :users
  has_many :locations
  has_many :vehicles
  has_many :products
  has_many :orders
  has_many :trips

  validates :name, presence: true
  validates :address, presence: true
  validates :contact_email, presence: true
  validates :contact_phone, presence: true
  validates :subscription_tier, presence: true
  validates :status, presence: true
end