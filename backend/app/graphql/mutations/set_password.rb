module Mutations
  class SetPassword < BaseMutation
    graphql_name "SetPassword"
    description "SetPassword"

    argument :password, GraphQL::Types::String, required: true

    field :user, Types::UserType, null: true

    def resolve(password:)
      user = User.transaction do
        current_user.lock!
        if current_user.database_authentication.password.nil?
          current_user.database_authentication.update!(password:)
          current_user
        else
          nil
        end
      end
      { user: }
    end
  end
end
