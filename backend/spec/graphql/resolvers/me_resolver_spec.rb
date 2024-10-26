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
    let!(:user) { create(:user) }
    let!(:user_email) { create(:user_email, user:, email: 'alice@example.com') }
    let!(:variables) { {} }
    let!(:context) { { current_user: user } }

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
