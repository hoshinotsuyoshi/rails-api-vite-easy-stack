module Mutations
  class Signup < BaseMutation
    graphql_name "Signup"
    description "Signup"

    argument :email_address, GraphQL::Types::String, required: true

    field :success, GraphQL::Types::Boolean, null: false
    field :errors, [Types::Errors::SignupError], null: false

    def resolve(email_address:)
      user = nil
      errors = []
      ApplicationRecord.transaction do
        user = User.create_with!(email_address:) unless UserEmail.find_by(email_address:)
      end
      if user&.valid?
        InvitationMailer.invite(user.email.id).deliver_later
        success = true
      else
        errors << :taken
        success = false
      end
      { success:, errors: }
    end
  end
end
