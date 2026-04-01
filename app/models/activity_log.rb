class ActivityLog < ApplicationRecord
  belongs_to :user
  belongs_to :exercise
  belongs_to :sitting_session, optional: true

  # 自由運動の場合のバリデーション(categoryがother）
  with_options if: :free_exercise_log? do
    validates :note, presence:  true, length: { maximum: 50 }
    validates :duration_minutes, presence: true, numericality: { only_integer: true, greater_than: 0 }
  end

  scope :today, -> { where(created_at: Time.zone.now.all_day) }

  # 運動記録を作成時にHP回復を実行
  before_create :apply_hp_recovery

  private

  # userの回復ロジックを使う
  def apply_hp_recovery
    user.recover(calculate_recovery_amount)
  end

  def calculate_recovery_amount
    # 自由運動の際の回復量を設定（コンセプト上まとめて行っても回復量は増えない）
    if free_exercise_log?
      if duration_minutes <= 20
        duration_minutes
      else
        # 20分以上まとめて運動しても回復量は比例しない
        (20 + (duration_minutes - 20) * 0.2).round
      end
    end
  end

  def free_exercise_log?
    exercise&.category == "other"
  end
end
