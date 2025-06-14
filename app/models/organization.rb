class Organization < ApplicationRecord
  has_many :users, dependent: :destroy
  has_many :locations, dependent: :destroy
  has_many :vehicles, dependent: :destroy
  has_many :products, dependent: :destroy
  has_many :orders, dependent: :destroy
  has_many :trips, dependent: :destroy

  validates :name, presence: true
  validates :contact_email, presence: true
  validates :contact_phone, presence: true
  validates :status, presence: true
end