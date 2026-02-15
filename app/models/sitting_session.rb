class SittingSession < ApplicationRecord

  SETTING_DURATIONS = [ 30, 60, 90 ].freeze

  belongs_to :user

  has_many :suggested_actions, dependent: :destroy
  # 中間テーブルを介してexerciseへ
  has_many :exercises, through: :suggested_actions

  # 3. Enums (列挙型)
  enum :status, { active: 0, completed: 1, cancelled: 2 }

  # 4. Callbacks (コールバック)
  before_create :cancel_active_sessions
  
  # 終了時刻の計算
  def end_time
    # durationを一元管理
    created_at + duration.seconds
    # secondsはminutesに戻す予定
    # created_at + duration.minutes
  end

  # 現在時刻が終了時刻より前ではないか？
  def in_progress?
    # デバッグ後にTime.current < end_time && 追加
    !notified?
  end

  private

  def cancel_active_sessions
    user.sitting_sessions.active.where.not(id: id).update_all(status: :cancelled)
  end
end
