module Types
  class ProductType < Types::BaseObject
    implements NodeType
    field :name, String, null: false
    field :description, String, null: false
    field :unit_price, Float, null: false # TODO: Decimal
    field :stock, Integer, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
  end
end
