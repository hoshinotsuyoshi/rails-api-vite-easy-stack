module Mutations
  class VerifyEmailAddress < BaseMutation
    graphql_name "VerifyEmailAddress"
    description "Verify email address"

    argument :signed_id, GraphQL::Types::String, required: true

    field :success, GraphQL::Types::Boolean, null: false

    def resolve(signed_id:)
      user = nil
      User.transaction do
        user = User
          .lock
          .find_signed(signed_id, purpose: :invite)
        next unless user
        user.update!(onboarding_status: :before_set_own_password) if user.before_verify_email_address_status?
        start_new_session_for(user)
      end
      { success: !!user }
    end
  end
end
