module Mutations
  class Signup < BaseMutation
    graphql_name "Signup"
    description "Signup"
    type Types::UserType

    argument :email_address, GraphQL::Types::String, required: true

    def resolve(email_address:)
      user = User.create!(
        email_address:, password: SecureRandom.uuid, onboarding_status: :before_verify_email_address
      )
      InvitationMailer.invite(user).deliver_later
      user
    end
  end
end
