class SittingSession < ApplicationRecord
  # タイマーの時間選択肢
  SETTING_DURATIONS = [ 30, 60, 90 ].freeze
  # 一日の座位時間上限(11時間を秒に換算)
  SITTING_TIME_LIMIT = 11 * 60 * 60

  belongs_to :user

  has_many :suggested_actions, dependent: :destroy
  # 中間テーブルを介してexerciseへ
  has_many :exercises, through: :suggested_actions

  has_many :activity_logs, dependent: :nullify

  # Enums (列挙型)
  enum :status, { active: 0, completed: 1, cancelled: 2 }

  # Callbacks (コールバック)
  before_create :cancel_active_sessions

  # 今日のセッションを取得
  scope :today, -> { where(created_at: Time.zone.now.all_day) }

  # 終了時刻の計算
  def end_time
    # デバッグ時に使用
    created_at + duration.seconds
    #created_at + duration.minutes
  end

  # 現在時刻が終了時刻より前ではないか？
  def in_progress?
    !notified?
 end

  private

  def cancel_active_sessions
    user.sitting_sessions.active.where.not(id: id).update_all(status: :cancelled)
  end

  validates :start_at, presence: true
end
