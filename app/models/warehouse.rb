class Warehouse < ApplicationRecord
    belongs_to :organization
    has_many :inventories, dependent: :destroy
    has_many :products, through: :inventories

    validates :name, presence: true
    validates :address, presence: true
end
