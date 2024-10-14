require 'rails_helper'

RSpec.describe Ec::Purchase, type: :model do
  it { is_expected.to belong_to(:cart) }
end
