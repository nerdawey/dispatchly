# app/models/product.rb
class Product < ApplicationRecord
  belongs_to :organization
  has_many :order_items, dependent: :destroy
  has_many :orders, through: :order_items

  validates :sku, presence: true, uniqueness: { scope: :organization_id }
  validates :weight, presence: true, numericality: { greater_than: 0 }
  validates :length, numericality: { greater_than: 0 }, allow_nil: true
  validates :width, numericality: { greater_than: 0 }, allow_nil: true
  validates :height, numericality: { greater_than: 0 }, allow_nil: true
  validates :storage_temperature, presence: true
  validates :number_of_boxes, numericality: { greater_than: 0 }, allow_nil: true

  enum :storage_temperature, { ambient: 0, chilled: 1, frozen: 2 }, prefix: true
end
