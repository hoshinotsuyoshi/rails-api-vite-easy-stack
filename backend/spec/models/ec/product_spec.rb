require 'rails_helper'

RSpec.describe Ec::Product, type: :model do
  it { is_expected.to have_many(:cart_items).dependent(:destroy) }
end
