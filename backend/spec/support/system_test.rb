require 'capybara/rspec'

Capybara.server = :puma, { Silent: true }

RSpec.configure do |config|
  using = ENV['SYSTEM_TEST_BROWSER']&.to_sym

  config.before(:each, type: :system) do
    # Before each system test, set the driver to either headless_chrome or headless_firefox
    # If no environment variable is provided, randomly choose between the two and log the selection.
    using ||= [:headless_chrome, :headless_firefox].sample.tap do |driver|
      puts "System test: #{driver} has been randomly selected."
    end
    driven_by :selenium, using:
  end
end

m = Module.new {
  private def chrome_driver?
    page.driver.options.dig(:browser) == :chrome
  end
}
RSpec.configure do |config|
  config.include(m, type: :system)
end
