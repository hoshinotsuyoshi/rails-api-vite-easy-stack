require 'rails_helper'

RSpec.describe "login flow", type: :system do
  let!(:user) { create(:user, :onboarded) }

  it 'me -> login -> me -> logout -> me -> login' do
    visit '/me'
    expect(page).to have_no_content("hello, It's me!")

    fill_in "email", with: user.email.email
    fill_in "password", with: user.database_authentication.password
    click_button "Login"

    expect(page).to have_content(user.email.email)
    expect(page).to have_content("hello, It's me!")
    accept_alert do
      click_button "Logout"
    end

    expect(page).to have_content("Login")
    expect(current_path).to eq("/login")
  end
end
