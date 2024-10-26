FactoryBot.define do
  factory :user_email do
    association(:user)
    email_address { "#{SecureRandom.alphanumeric}@example.com" }
    confirmed_at { Time.current }
  end
end
