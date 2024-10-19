require 'rails_helper'

RSpec.describe "login flow", type: :system do
  before do
    driven_by(:headless_chrome)
  end
  let!(:user) { create(:user) }

  it 'me -> login -> me -> logout -> me -> login' do
    visit '/login'
    expect(page).not_to have_content("hello, It's me!")

    fill_in "email", with: user.email_address
    fill_in "password", with: user.password
    click_button "Login"

    expect(page).to have_content("hello, It's me!")
    expect(page).to have_content(user.email_address)
    accept_alert do
      click_button "Logout"
    end   
    expect(page).to have_content("Login")
    expect(current_path).to eq("/login")
  end
end
