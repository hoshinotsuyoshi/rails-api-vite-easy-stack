module Types::Errors
  class SomethingWrongType < Types::BaseObject
    field :message, String, null: false

    def messsage
      "something wrong"
    end
  end
end
