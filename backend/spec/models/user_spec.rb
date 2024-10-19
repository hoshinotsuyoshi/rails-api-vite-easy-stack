require 'rails_helper'

RSpec.describe User, type: :model do
  it { is_expected.to have_secure_password }
  it { is_expected.to have_many(:sessions).dependent(:destroy) }
  it { is_expected.to normalize(:email_address).from(" Alice@Example.com ").to("alice@example.com") }
end
