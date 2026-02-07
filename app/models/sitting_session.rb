class SittingSession < ApplicationRecord
  belongs_to :user

  has_many :suggested_actions, dependent: :destroy
  # 中間テーブルを介してexerciseへ
  has_many :exercises, through: :suggested_actions

  #タイマーの選択可能時間
  SETTING_DURATIONS = [30, 60, 90].freeze
end
