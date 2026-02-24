FactoryBot.define do
  factory :sitting_session do
    association :user 
    start_at { Time.current }
  end
end
