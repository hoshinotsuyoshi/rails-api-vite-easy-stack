require 'rails_helper'

RSpec.describe Ec::CartItem, type: :model do
  it { is_expected.to belong_to(:cart) }
  it { is_expected.to belong_to(:product) }
end
