class Exercise < ApplicationRecord
  has_many :suggested_actions, dependent: :destroy
  has_many :sitting_sessions, through: :suggested_actions

  enum :category, { stretch: 0, training: 1, walk: 2 }

  validates :name, presence: true
  validates :category, presence: true
end


