# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Mutations::Login, type: :request do
  describe '#resolve' do
    subject { BackendSchema.execute(query_string, variables:, context:) }
    let!(:query_string) do
      <<~GRAPHQL
        mutation ($loginInput: LoginInput!) {
          login(input: $loginInput) {
            success
            errors {
              __typename
            }
          }
        }
      GRAPHQL
    end

    let!(:current_user) { nil }
    let!(:request) { Request.new(user_agent: 'user-agent', remote_ip: '10.0.0.1') }
    let!(:context) { { current_user:, request:, cookies: } }
    let!(:cookies) do
      # NOTE: we should test this at spec/requests
      double(:permanent, :[]= => nil )
        .then { double(:signed, permanent: _1) }
        .then { instance_double(ActionDispatch::Cookies::CookieJar, signed: _1) }
    end
    let!(:variables) do
      {
        loginInput: {
          emailAddress: "alice@example.com",
          password: "password",
        }
      }
    end

    context "when password is correct" do
      before do
        user = create(:user)
        create(:user_email, user:, email: "alice@example.com")
        create(:user_database_authentication, user:, password: "password")
      end
      it "no errors" do
        expect { subject }.to change(Session, :count).by(1)
        expect(subject_response_to_hash).to match(
          data: {
            login: {
              success: true,
              errors: [],
            },
          },
        )
      end
    end

    context "when password is wrong" do
      it "null User" do
        expect { subject }.not_to change(Session, :count)
        expect(subject_response_to_hash).to eq(
          data: {
            login: {
              success: false,
              errors: [
                __typename: "SomethingWrong",
              ],
            },
          },
        )
      end
    end
  end
end
