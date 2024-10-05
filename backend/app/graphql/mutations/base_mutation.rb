# frozen_string_literal: true

module Mutations
  class BaseMutation < GraphQL::Schema::RelayClassicMutation
    argument_class Types::BaseArgument
    field_class Types::BaseField
    input_object_class Types::BaseInputObject
    object_class Types::BaseObject

    include Authentication

    private def current_user = context.fetch(:current_user)
    private def request = context.fetch(:request)
    private def cookies = context.fetch(:cookies)
  end
end
