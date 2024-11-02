require 'capybara/rspec'

Capybara.server = :puma, { Silent: true }

RSpec.configure do |config|
  using = ENV['SYSTEM_TEST_BROWSER']&.to_sym

  config.before(:each, type: :system) do
    using ||= [:chromium, :firefox].sample.tap do |driver|
      puts "System test: #{driver} has been randomly selected."
    end
    driven_by :playwright, options: { headless: true, browser_type: using }
  end
end
