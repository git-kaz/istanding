class SittingSession < ApplicationRecord
  belongs_to :user

  has_many :suggested_actions, dependent: :destroy
  # 中間テーブルを介してexerciseへ
  has_many :exercises, through: :suggested_actions

  # タイマーの選択可能時間
  SETTING_DURATIONS = [ 30, 60, 90 ].freeze

  # 終了時刻の計算
  def end_time
    # デバッグ用
    created_at + duration.seconds
    # secondsはminutesに戻す予定
    # created_at + duration.minutes
  end

  # 現在時刻が終了時刻より前ではないか？
  def in_progress?
    # デバッグ後にTime.current < end_time && 追加
    !notified?
  end
end
