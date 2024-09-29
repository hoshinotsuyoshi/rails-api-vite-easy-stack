module Mutations
  class Login < BaseMutation
    graphql_name 'Login'

    type Types::UserType

    argument :email_address, GraphQL::Types::String, required: true
    argument :password, GraphQL::Types::String, required: true

    def resolve(email_address:, password:)
      user = User.authenticate_by(email_address:, password:)
      user && start_new_session_for(user)
      user
    end
  end
end
