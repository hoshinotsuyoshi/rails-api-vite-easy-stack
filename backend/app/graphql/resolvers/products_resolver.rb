module Resolvers
  class ProductsResolver < BaseResolver
    description "Fetch all Products"
    type Types::ProductType.connection_type, null: false

    def resolve
      Ec::Product.all
    end
  end
end
