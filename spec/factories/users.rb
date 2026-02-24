FactoryBot.define do
  factory :user do
    username { "テストユーザー" }
    #毎回違うアドレスを生成
    sequence (:email) { |n| "test#{n}@example.com" }
    password { "password" }
    password_confirmation { "password" }
  end
end
