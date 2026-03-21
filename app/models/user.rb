class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [ :google_oauth2 ]

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

  # 座位時間の集計
  def daily_sitting_hours(days: 7)
    sitting_sessions
    .where(start_at: days.days.ago.beginning_of_day..)
    .where(status: :completed)
    .group_by_day(:created_at, last: days, time_zone: "Tokyo")
    .sum(:duration)
    .transform_keys { |date| date.strftime("%-m/%-d") }  # キーを月/日に変換
    .transform_values { |seconds| [ (seconds / 3600.0).round(1), SittingSession::SITTING_TIME_LIMIT / 3600.0 ].min }
  end

  # 運動回数の集計
  def daily_exercise_counts(days: 7)
    activity_logs
    .where(created_at: days.days.ago.beginning_of_day..)
    .group_by_day(:created_at, last: days, time_zone: "Tokyo")
    .count
  end

  # ダメージゲージの計算
  def take_damage(duration)
    damage = (duration / 3600.0 * 10).round # 1時間で10ダメージ
    update(hp: [ hp - damage, 0 ].max)  # 0未満にならないように
  end

  def recover(amount = 10)
    update(hp: [ hp + amount, 100 ].min) # 101以上にならないように
  end


  # ゲストログインの実装
  def self.guest
    find_or_create_by!(email: "guest@example.com") do |user|
      user.password = SecureRandom.urlsafe_base64
      user.username = "ゲストユーザー"
    end
  end

def self.from_omniauth(auth)
  user = where(provider: auth.provider, uid: auth.uid)
           .or(where(email: auth.info.email))
           .first_or_create do |u|
             u.email = auth.info.email
             u.password = Devise.friendly_token[0, 20]
             u.username = auth.info.name
             u.provider = auth.provider
             u.uid = auth.uid
           end

  # 既存ユーザーの場合もprovider/uidを更新
  user.update(provider: auth.provider, uid: auth.uid) unless user.provider.present?
  user
end

  validates :email, presence: true, uniqueness: true
  validates :password, presence: true, length: { minimum: 6 }, if: -> { password.present? }
  validates :hp, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }
end
