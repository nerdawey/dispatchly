class Organization < ApplicationRecord
  has_many :users
  has_many :warehouses
  has_many :orders, through: :warehouses
  has_many :products, through: :warehouses
  has_many :trips
end