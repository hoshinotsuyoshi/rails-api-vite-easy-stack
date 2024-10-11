module Mutations
  class Signup < BaseMutation
    graphql_name "Signup"
    description "Signup"

    argument :email_address, GraphQL::Types::String, required: true

    field :user, Types::UserType, null: true
    field :errors, [Types::Errors::SignupError], null: false

    def resolve(email_address:)
      user = nil
      errors = []
      ApplicationRecord.transaction do
        user = User.create(
          email_address:, password: SecureRandom.uuid, onboarding_status: :before_verify_email_address
        )
      end
      if user.valid?
        InvitationMailer.invite(user).deliver_later
      else
        errors += user.errors.errors
        user = nil
      end
      { user:, errors: }
    end
  end
end
