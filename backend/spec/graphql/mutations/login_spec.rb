# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Mutations::Login, type: :request do
  describe '#resolve' do
    subject { BackendSchema.execute(query_string, variables:, context:) }
    let!(:query_string) do
      <<~GRAPHQL
        mutation ($loginInput: LoginInput!) {
          login(input: $loginInput) {
            id
            emailAddress
          }
        }
      GRAPHQL
    end

    let!(:context) { { } }
    let!(:variables) do
      {
        loginInput: {
          emailAddress: "alice@example.com",
          password: "password",
        }
      }
    end

    context "when password is wrong" do
      it "null User" do
        expect { subject }.not_to change(Session, :count)
        expect(subject_response_to_hash).to eq(
          data: {
            login: nil
          }
        )
      end
    end
  end
end
