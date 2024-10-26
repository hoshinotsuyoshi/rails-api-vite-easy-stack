require 'rails_helper'

RSpec.describe Mutations::Signup, type: :request do
  describe '.resolve' do
    subject { BackendSchema.execute(query_string, variables:, context:) }
    let!(:query_string) do
      <<~GRAPHQL
        mutation ($signupInput: SignupInput!) {
          signup(input: $signupInput) {
            success
            errors {
              __typename
            }
          }
        }
      GRAPHQL
    end

    context 'when signup is successful' do
      let!(:variables) do
        {
          signupInput: {
            emailAddress: email_address,
          }
        }
      end
      let!(:email_address) { 'test@example.com' }
      let!(:context) { {} }

      it 'creates a new user and returns no errors' do
        expect { subject }.to change { User.count }.by(1)
        expect(subject_response_to_hash).to match(
          data: {
            signup: {
              success: true,
              errors: [],
            },
          },
        )
      end

      it 'sends an invitation email' do
        expect { subject }
          .to have_enqueued_job(ActionMailer::MailDeliveryJob)
          .with('InvitationMailer', 'invite', 'deliver_now', { args: [be_a(String)] })
        expect(subject_response_to_hash).to match(
          data: {
            signup: {
              success: true,
              errors: [],
            },
          },
        )
      end
    end

    context 'when already user exists' do
      let!(:variables) do
        {
          signupInput: {
            emailAddress: email_address,
          }
        }
      end
      let!(:email_address) { 'test@example.com' }
      let!(:context) { {} }

      before do
        user = create(:user)
        create(:user_email, user:, email: "test@example.com")
      end

      it 'does not send invitation email' do
        expect { subject }
          .not_to have_enqueued_job(ActionMailer::MailDeliveryJob)
        expect(subject_response_to_hash).to match(
          data: {
            signup: {
              success: false,
              errors: [
                { __typename: "Taken" },
              ],
            },
          },
        )
      end
    end
  end
end
