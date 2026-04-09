class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [ :google_oauth2 ]

  has_many :sitting_sessions, dependent: :destroy
  has_many :activity_logs, dependent: :destroy
  has_many :exercises, through: :activity_logs

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
