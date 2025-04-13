class User < ApplicationRecord
  belongs_to :organization
  
  has_secure_password
  
  enum role: { admin: 0, planner: 1, dispatcher: 2 }
  
  validates :email, presence: true, uniqueness: true
  validates :first_name, :last_name, presence: true
end