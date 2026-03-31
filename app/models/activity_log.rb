class ActivityLog < ApplicationRecord
  belongs_to :user
  belongs_to :exercise
  belongs_to :sitting_session, optional: true

  # 自由運動の場合のバリデーション(categoryがother）
  with_options if if: :free_exercise_log? do
    validates :note, presence:  true, length: { maximum: 50 }
    validates :duration_minutes, presence: true, numericality: { only_integer: true, greater_than: 0 }
  end

  scope :today, -> { where(created_at: Time.zone.now.all_day) }

  private

  def free_exercise_log?
    exercise&.category == "other"
  end
end
