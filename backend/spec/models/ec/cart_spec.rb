require 'rails_helper'

RSpec.describe Ec::Cart, type: :model do
  it { is_expected.to belong_to(:user) }
  it { is_expected.to have_many(:cart_items).dependent(:destroy) }
  it { is_expected.to have_one(:purchase).dependent(:destroy) }
end
