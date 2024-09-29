module Mutations
  class VerifyEmailAddress < BaseMutation
    graphql_name "VerifyEmailAddress"
    description "Verify email address"
    type Types::UserType

    argument :signed_id, GraphQL::Types::String, required: true

    def resolve(signed_id:)
      User.transaction do
        user = User
          .lock
          .before_verify_email_address_status
          .find_signed(signed_id, purpose: :invite)
        next unless user
        start_new_session_for(user) # TODO: cookieのあつかい
        user
      end
    end
  end
end
