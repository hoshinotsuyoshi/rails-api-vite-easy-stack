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
      user = UserEmail.verified.find_by(email_address:)&.user
      if user
        auth = UserDatabaseAuthentication.authenticate_by(user:, password:)
        if auth
          start_new_session_for(auth.user)
        else
          errors << :something_wrong
        end
      else
        errors << :something_wrong
      end

      { success: !!user, errors: }
    end
  end
end
