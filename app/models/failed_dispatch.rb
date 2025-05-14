class FailedDispatch < ApplicationRecord
  belongs_to :orders, polymorphic: true

  validates :reason, presence: true
  validates :attempted_at, presence: true

  scope :recent, -> { where("attempted_at > ?", 24.hours.ago) }
  scope :unresolved, -> { where(resolved_at: nil) }

  def resolve!
    update!(resolved_at: Time.current)
  end

  def resolved?
    resolved_at.present?
  end
end
