# frozen_string_literal: true

module Types::Errors
  class LoginError < Types::BaseUnion
    comment "TODO comment on the union"
    description "Objects which may be commented on"
    possible_types Types::Errors::SomethingWrongType

    def self.resolve_type(_object, _context)
      # TODO: Implement
      Types::Errors::SomethingWrongType
    end
  end
end

