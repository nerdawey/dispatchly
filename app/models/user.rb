class User < ApplicationRecord
  enum :role, { super_admin: 1, org_admin: 2, planner: 3, dispatcher: 4 }
  has_secure_password
  has_many :sessions, dependent: :destroy
  belongs_to :organization, optional: true

  validates :email_address, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :role, presence: true
  validates :password, presence: true, length: { minimum: 6 }, on: :create
  validate :organization_presence_unless_super_admin

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  private

  def organization_presence_unless_super_admin
    if !super_admin? && organization.nil?
      errors.add(:organization, "must exist unless user is a super admin")
    end
  end
end
