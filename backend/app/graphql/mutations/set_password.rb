module Mutations
  class SetPassword < BaseMutation
    graphql_name "SetPassword"
    description "SetPassword"

    argument :password, GraphQL::Types::String, required: true

    field :user, Types::UserType, null: true

    def resolve(password:)
      user = User.transaction do
        current_user.lock!
        if current_user.before_set_own_password_status?
          curret_user.update!(onboarding_status: :onboarded)
          curret_user
        else
          nil
        end
      end
      { user: }
    end
  end
end
