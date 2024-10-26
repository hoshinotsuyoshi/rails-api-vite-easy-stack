FactoryBot.define do
  factory :user_database_authentication do
    association(:user)
    password { SecureRandom.alphanumeric }
  end
end
