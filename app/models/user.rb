class User < ApplicationRecord
  enum role: { super_admin: 0, org_admin: 1, planner: 2, dispatcher: 3 }

  has_secure_password
  has_many :sessions, dependent: :destroy

  belongs_to :organization, optional: true
  normalizes :email_address, with: ->(e) { e.strip.downcase }
end
