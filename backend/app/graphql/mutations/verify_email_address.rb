module Mutations
  class VerifyEmailAddress < BaseMutation
    graphql_name "VerifyEmailAddress"
    description "Verify email address"

    argument :signed_id, GraphQL::Types::String, required: true

    field :success, GraphQL::Types::Boolean, null: false

    def resolve(signed_id:)
      user_email = nil
      UserEmail.transaction do
        user_email = UserEmail
          .lock
          .find_signed(signed_id, purpose: :invite)
        next unless user_email
        user_email.touch(:confirmed_at) # rubocop:disable Rails/SkipsModelValidations
        start_new_session_for(user_email.user)
      end
      { success: !!user_email }
    end
  end
end
