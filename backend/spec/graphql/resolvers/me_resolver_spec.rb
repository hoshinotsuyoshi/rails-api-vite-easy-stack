# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Resolvers::MeResolver, type: :request do
  describe '#resolve' do
    subject { BackendSchema.execute(query_string, variables:, context:) }

    let!(:query_string) do
      <<~GRAPHQL
        query {
          me {
            emailAddress
          }
        }
      GRAPHQL
    end
    let!(:current_user) { User.new(email_address: "alice@example.com") }
    let!(:variables) { {} }
    let!(:context) { { current_user: } }

    it "returns me" do
      expect(subject_response_to_hash).to eq(
        data: {
          me: {
            emailAddress: "alice@example.com",
          },
        }
      )
    end
  end
end
