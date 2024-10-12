require 'rails_helper'

RSpec.describe Mutations::Signup, type: :request do
  describe '.resolve' do
    let!(:email_address) { 'test@example.com' }
    let!(:invalid_email) { '' }

    context 'when signup is successful' do
      it 'creates a new user and returns no errors' do
        expect do
          post '/graphql', params: { query: mutation(email_address) }
        end.to change { User.count }.by(1)

        json_response = JSON.parse(response.body)
        data = json_response['data']['signup']

        expect(data['user']['emailAddress']).to eq(email_address)
        expect(data['errors']).to be_empty
      end

      it 'sends an invitation email' do
        expect do
          post '/graphql', params: { query: mutation(email_address) }
        end.to have_enqueued_job(ActionMailer::MailDeliveryJob)
          .with('InvitationMailer', 'invite', 'deliver_now', { args: [be_a(String)] })

        json_response = JSON.parse(response.body)
        data = json_response['data']['signup']

        expect(data['errors']).to be_empty
      end
    end

    context 'when signup fails' do
      xit 'does not create a user and returns errors'
    end
  end

  def mutation(email_address)
    <<~GQL
      mutation {
        signup(input: { emailAddress: "#{email_address}" }) {
          user {
            emailAddress
          }
          errors {
            __typename
          }
        }
      }
    GQL
  end
end
