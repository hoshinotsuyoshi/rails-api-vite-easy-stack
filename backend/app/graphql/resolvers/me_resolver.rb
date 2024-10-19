module Resolvers
  class MeResolver < BaseResolver
    description "Fetch current session"
    type Types::UserType, null: true

    def resolve
      current_user
    end
  end
end
