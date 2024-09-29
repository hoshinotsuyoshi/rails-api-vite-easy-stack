# frozen_string_literal: true

module Resolvers
  class BaseResolver < GraphQL::Schema::Resolver
    include Authentication

    private def current_user = context.fetch(:current_user)
    private def request = context.fetch(:request)
  end
end
