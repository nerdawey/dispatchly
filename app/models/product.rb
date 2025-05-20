# app/models/product.rb
class Product < ApplicationRecord
  belongs_to :organization
  has_many :inventories
  has_many :orders

  validates :name, :sku, presence: true
  validates :sku, uniqueness: { scope: :organization_id }

  enum :storage_temperature, { ambient: 0, chilled: 1, frozen_temp: 2 }
end
