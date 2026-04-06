FactoryBot.define do
  factory :activity_log do
    association :user
    association :exercise
  end
end
