require 'rails_helper'

RSpec.describe User, type: :model do
  it { is_expected.to have_many(:sessions).dependent(:destroy) }
  it { is_expected.to have_one(:database_authentication).dependent(:destroy) }
  it { is_expected.to have_one(:email).dependent(:destroy) }
end
