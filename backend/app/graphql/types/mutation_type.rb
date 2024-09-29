# frozen_string_literal: true

module Types
  class MutationType < Types::BaseObject
    field :login, mutation: Mutations::Login, null: true
    field :signup, mutation: Mutations::Signup, null: true
    field :verify_email_address, mutation: Mutations::VerifyEmailAddress, null: true
  end
end
