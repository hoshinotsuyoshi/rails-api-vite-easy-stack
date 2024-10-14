module Types
  class UserType < Types::BaseObject
    implements NodeType
    field :email_address, String, null: false

    def self.authorized?(object, context)
      super && object == context.fetch(:current_user)
    end
  end
end
