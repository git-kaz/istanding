FactoryBot.define do
  factory :sitting_session do
    association :user 
    status { :active }
    start_at { Time.current }
  end
end
