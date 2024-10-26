class UserDatabaseAuthentication < ApplicationRecord
  has_secure_password

  belongs_to :user, inverse_of: :database_authentication
end
