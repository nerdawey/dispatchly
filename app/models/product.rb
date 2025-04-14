# app/models/product.rb
class Product < ApplicationRecord
  has_many :inventories
  has_many :orders

  enum storage_temperature: { ambient: 0, chilled: 1, frozen: 2 }
end
