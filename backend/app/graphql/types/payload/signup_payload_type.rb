module Types::Payload
  class SignupPayloadType < Types::BaseObject
    field :user, Types::UserType, null: true
    field :errors, [Types::Errors::SignupError], null: false
  end
end
