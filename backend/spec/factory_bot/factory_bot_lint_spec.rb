# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FactoryBot, type: :model do
  describe '.lint', tenant_creation: :unlimited do
    it 'no errors' do
      targets = FactoryBot.factories
      FactoryBot.lint(targets, traits: true)
    end
  end
end
