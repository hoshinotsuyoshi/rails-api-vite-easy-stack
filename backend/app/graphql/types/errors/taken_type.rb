module Types::Errors
  class TakenType < Types::BaseObject
    field :message, String, null: false

    def messsage
      "taken"
    end
  end
end
