module Types::Errors
  class TakenType < Types::BaseObject
    field :message, GraphQL::Types::String, null: false

    def messsage
      "taken"
    end
  end
end
