module Mutations
  class VerifyEmailAddress < BaseMutation
    graphql_name "VerifyEmailAddress"
    description "Verify email address"
    type Types::UserType

    argument :signed_id, GraphQL::Types::String, required: true

    def resolve(signed_id:)
      user = User.find_signed(signed_id, purpose: :invite)
      user && start_new_session_for(user)
      user
    end
  end
end
