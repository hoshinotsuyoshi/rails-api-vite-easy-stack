# frozen_string_literal: true

module Types
  class MutationType < Types::BaseObject
    field :login, mutation: Mutations::Login, null: false
    field :logout, mutation: Mutations::Logout, null: false
    field :set_password, mutation: Mutations::SetPassword, null: false
    field :signup, mutation: Mutations::Signup, null: false
    field :verify_email_address, mutation: Mutations::VerifyEmailAddress, null: false
  end
end
