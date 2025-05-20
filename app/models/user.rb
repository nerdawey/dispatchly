class User < ApplicationRecord
  enum role: { super_admin: 1, org_admin: 2, planner: 3, dispatcher: 4 }
  has_secure_password
  has_many :sessions, dependent: :destroy
  validate :organization_presence_unless_super_admin

  belongs_to :organization, optional: true
  normalizes :email_address, with: ->(e) { e.strip.downcase }
  private

  def organization_presence_unless_super_admin
    if !super_admin? && organization.nil?
      errors.add(:organization, "must exist unless user is a super admin")
    end
  end
end
