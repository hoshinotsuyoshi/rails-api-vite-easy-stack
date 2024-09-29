module Mutations
  class VerifyEmailAddress < BaseMutation
    graphql_name "VerifyEmailAddress"
    description "Verify email address"
    type Types::UserType

    argument :signed_id, GraphQL::Types::String, required: true

    def resolve(signed_id:)
      User.find_signed(signed_id, purpose: :invite)
    end
  end
end
