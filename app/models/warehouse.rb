class Warehouse < ApplicationRecord
    belongs_to :organization
    has_many :inventories
    has_many :products, through: :inventories
end
