class Exercise < ApplicationRecord
  has_one_attached :image
  has_many :activity_logs
  enum :category, { stretch: 0, training: 1, other: 2 }

  validates :name, presence: true
  validates :category, presence: true

  # 表示する運動を分けるフラグ
  scope :active, -> { where(active: true) }
end
