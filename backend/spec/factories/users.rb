FactoryBot.define do
  factory :user do
    trait :onboarded do
      after(:create) do |instance|
        create(:user_database_authentication, user: instance)
        create(:user_email, user: instance)
      end
    end
  end
end
