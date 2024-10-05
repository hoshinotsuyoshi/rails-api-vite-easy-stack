module Types::Payload
  class LoginPayloadType < Types::BaseObject
    field :user, Types::UserType, null: true
    field :errors, [Types::Errors::LoginError], null: false
  end
end
