module Mutations
  class Login < BaseMutation
    graphql_name "Login"
    description "Login"
    type Types::Payload::LoginPayloadType

    argument :email_address, GraphQL::Types::String, required: true
    argument :password, GraphQL::Types::String, required: true

    def resolve(email_address:, password:)
      errors = []
      user = User.authenticate_by(email_address:, password:)
      if user
        start_new_session_for(user)
      else
        # TODO: Implement
        error = Object.new
        errors << error
      end
      { user:, errors: }
    end
  end
end
