module Mutations
  class Logout < BaseMutation
    graphql_name "Logout"
    description "Logout"

    field :logout, GraphQL::Types::Boolean, null: false

    def resolve
      terminate_session
      { logout: true }
    end
  end
end
