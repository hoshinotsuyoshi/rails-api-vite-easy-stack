module Mutations
  class Login < BaseMutation
    graphql_name "Login"
    description "Login"

    argument :email_address, GraphQL::Types::String, required: true
    argument :password, GraphQL::Types::String, required: true

    field :success, GraphQL::Types::Boolean, null: false
    field :errors, [Types::Errors::LoginError], null: false

    def resolve(email_address:, password:)
      errors = []
      user = User.authenticate_by(email_address:, password:)
      if user
        start_new_session_for(user)
      else
        error = :something_wrong
        errors << error
      end

      { success: !!user, errors: }
    end
  end
end
