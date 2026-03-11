class SittingSession < ApplicationRecord
  # タイマーの時間選択肢
  SETTING_DURATIONS = [ 30, 60, 90 ].freeze
  # 一日の座位時間上限(11時間を秒に換算)
  SITTING_TIME_LIMIT = 11 * 60 * 60

  belongs_to :user

  has_many :activity_logs, dependent: :nullify

  enum :status, { active: 0, completed: 1, cancelled: 2 }

  before_create :cancel_active_sessions
  before_validation :set_notification_time, if: :duration_changed?

  # 座位時間の終了予定時刻を計算して保存
  def set_notification_time
    return if duration.blank?

    self.start_at ||= Time.current

    self.notify_at = self.start_at + duration.seconds
    self.notified = false
  end

  scope :today, -> { where(created_at: Time.zone.now.all_day) }


  def end_time
    created_at + duration.minutes
  end

  private

  def cancel_active_sessions
    user.sitting_sessions.active.where.not(id: id).update_all(status: :cancelled)
  end

  validates :start_at, presence: true
end
