# app/models/product.rb
class Product < ApplicationRecord
  belongs_to :organization
  has_many :order_items
  has_many :orders, through: :order_items

  validates :name, presence: true
  validates :sku, presence: true, uniqueness: { scope: :organization_id }
  validates :weight, presence: true, numericality: { greater_than: 0 }
  validates :volume, presence: true, numericality: { greater_than: 0 }
  validates :required_temperature, presence: true
  validates :storage_temperature, presence: true

  enum :storage_temperature, { ambient: 0, chilled: 1, frozen: 2 }, prefix: true
end
