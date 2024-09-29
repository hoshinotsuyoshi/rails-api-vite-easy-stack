module Mutations
  class Signup < BaseMutation
    graphql_name "Signup"
    description "Signup"
    type Types::UserType

    argument :email_address, GraphQL::Types::String, required: true
    argument :password, GraphQL::Types::String, required: true

    def resolve(email_address:, password:)
    end
  end
end
