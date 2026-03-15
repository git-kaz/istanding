class Exercise < ApplicationRecord
  has_one_attached :image
  enum :category, { stretch: 0, training: 1, walk: 2 }

  validates :name, presence: true
  validates :category, presence: true
end
