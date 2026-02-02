class SittingSession < ApplicationRecord
  belongs_to :user
  
  has_many :suggested_actions, dependent: :destroy
  #中間テーブルを介してexerciseへ
  has_many :exercises, through: :suggested_actions

end
