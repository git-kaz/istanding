FactoryBot.define do
  factory :exercise do
    name { "ストレッチ" }
    category { :stretch }

    trait :other do
      name{ "自由運動"}
      category { :other }
    end
  end
end
