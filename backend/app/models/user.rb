class User < ApplicationRecord
  has_many :sessions, dependent: :destroy
  has_one :database_authentication, dependent: :destroy, class_name: :UserDatabaseAuthentication, inverse_of: :user
  has_one :email, dependent: :destroy, class_name: :UserEmail, inverse_of: :user

  delegate :email_address, to: :email

  class << self
    def create_with!(email_address:)
      create!
        .tap { _1.create_email!(email_address:) }
        .tap { _1.create_database_authentication!(password: SecureRandom.uuid) }
    end
  end
end
