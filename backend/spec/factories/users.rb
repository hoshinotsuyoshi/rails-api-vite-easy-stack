FactoryBot.define do
  factory :user do
    email_address { "#{SecureRandom.alphanumeric}@example.com" }
    password { SecureRandom.alphanumeric }
    onboarding_status { :onboarded }
  end
end
