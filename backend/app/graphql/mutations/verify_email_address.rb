module Mutations
  class VerifyEmailAddress < BaseMutation
    graphql_name "VerifyEmailAddress"
    description "Verify email address"

    argument :signed_id, GraphQL::Types::String, required: true

    field :user, Types::UserType, null: true

    def resolve(signed_id:)
      user = nil
      User.transaction do
        user = User
          .lock
          .before_verify_email_address_status
          .find_signed(signed_id, purpose: :invite)
        next unless user
        user.update!(onboarding_status: :before_set_own_password)
        start_new_session_for(user)
        user
      end
      { user: }
    end
  end
end
