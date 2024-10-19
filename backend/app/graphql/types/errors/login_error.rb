# frozen_string_literal: true

module Types::Errors
  class LoginError < Types::BaseUnion
    comment "TODO comment on the union"
    description "Objects which may be commented on"
    possible_types Types::Errors::SomethingWrongType

    def self.resolve_type(object, _context)
      case object
      when :something_wrong
        Types::Errors::SomethingWrongType
      else
        raise "Unexpected object: #{object}"
      end
    end
  end
end
