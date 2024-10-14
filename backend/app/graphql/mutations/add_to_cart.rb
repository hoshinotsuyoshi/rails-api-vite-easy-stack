module Mutations
  class AddToCart < BaseMutation
    graphql_name "AddToCart"
    description "Add to cart"

    argument :product_id, GraphQL::Types::ID, required: true

    field :product, Types::ProductType, null: true

    def resolve(product_id:)
      user = User.transaction do
        current_user.lock!
        if current_user.before_set_own_password_status?
          current_user.update!(onboarding_status: :onboarded, password:)
          current_user
        else
          nil
        end
      end
      { user: }
    end
  end
end
