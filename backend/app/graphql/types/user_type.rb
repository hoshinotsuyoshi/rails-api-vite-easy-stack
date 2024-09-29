module Types
  class UserType < Types::BaseObject
    field :id, ID, null: false
    field :email_address, String, null: false
  end
end
