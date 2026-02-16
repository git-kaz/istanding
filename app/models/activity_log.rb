class ActivityLog < ApplicationRecord
  belongs_to :user
  belongs_to :exercise
  belongs_to :sitting_session, optional: true

  scope :today, -> { where(created_at: Time.zone.now.all_day) }
end
