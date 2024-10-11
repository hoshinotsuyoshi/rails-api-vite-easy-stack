require 'rails_helper'

RSpec.describe "SPA Navigation", type: :system do
  before do
    driven_by(:headless_chrome)
  end

  it 'displays the login page' do
    visit '/login'

    # Adjust these selectors based on your actual HTML structure
    expect(page).to have_content('Login') # Or another identifier to confirm that the SPA is loading the login page
  end

  it 'displays the onboarding page' do
    visit '/onboarding/verify_email_address'

    expect(page).to have_content('Verify Email Address') # Adjust to your actual page content
  end
end
