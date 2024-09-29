require 'rails_helper'

RSpec.describe Session, type: :model do
  it { is_expected.to belong_to(:user) }
end
