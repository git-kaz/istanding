class SittingSession < ApplicationRecord
  # 1. Constants (定数)
  SETTING_DURATIONS = [30, 60, 90].freeze

  # 2. Associations (関連付け)
  belongs_to :user
  has_many :suggested_actions, dependent: :destroy
  has_many :exercises, through: :suggested_actions

  # 3. Enums (列挙型)
  enum :status, { active: 0, completed: 1, cancelled: 2 }

  # 4. Callbacks (コールバック)
  before_create :cancel_active_sessions

  # 5. Instance Methods (インスタンスメソッド)
  
  # 終了時刻の計算
  def end_time
    # durationの単位（秒か分か）が確定したら、ここを一元管理できるようにすると安全です
    created_at + duration.seconds
  end

  # 現在時刻が終了時刻より前ではないか？
  def in_progress?
    # TODO: デバッグ後に Time.current < end_time && を追加予定
    !notified?
  end

  private

  # 6. Private Methods
  def cancel_active_sessions
    user.sitting_sessions.active.where.not(id: id).update_all(status: :cancelled)
  end
end