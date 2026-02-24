class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :sitting_sessions, dependent: :destroy
  has_many :activity_logs, dependent: :destroy
  has_many :exercises, through: :activity_logs

  # 　一日の座位時間合計
  def today_total_sitting_seconds
    sitting_sessions.today.sum(:duration)
  end

  # 座位時間の上限を超えているか？
  def sitting_progress_percentage
    limit = SittingSession::SITTING_TIME_LIMIT
    [ ((today_total_sitting_seconds.to_f / limit) * 100).round, 100 ].min
  end

  # 今日の運動回数
  def today_exercise_count
    activity_logs.today.count
  end

  # ゲストログインの実装
  def self.guest
    find_or_create_by!(email: "guest@example.com") do |user|
      user.password = SecureRandom.urlsafe_base64
      user.username = "ゲストユーザー"
    end
  end

  validates :username, presence: true
  validates :email, presence: true, uniqueness: true
  validates :password, presence: true, length: { minimum: 6 }, if: :password_required?
end
