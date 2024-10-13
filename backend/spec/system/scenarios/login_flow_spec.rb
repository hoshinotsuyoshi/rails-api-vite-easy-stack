require 'rails_helper'

RSpec.describe "login flow", type: :system do
  include ActiveJob::TestHelper

  before do
    driven_by(:headless_chrome)
  end
  let!(:user) { create(:user) }

  it 'me -> login -> me' do
    visit '/me'

    fill_in "email", with: user.email_address
    fill_in "password", with: user.password
    click_button "Login"

    expect(page).to have_content("hello, It's me!")
    sleep 2
    expect(page).to have_content(user.email_address)
  end
end
