require 'rails_helper'

RSpec.describe "login flow", type: :system do
  let!(:user) { create(:user) }

  it 'me -> login -> me -> logout -> me -> login' do
    visit '/me'
    expect(page).to have_no_content("hello, It's me!")

    fill_in "email", with: user.email_address
    fill_in "password", with: user.password
    click_button "Login"

    retry_on_error { expect(page).to have_content(user.email_address) }
    expect(page).to have_content("hello, It's me!")
    accept_alert do
      click_button "Logout"
    end

    retry_on_error { expect(page).to have_content("Login") }
    expect(current_path).to eq("/login")
  end

  # There is a known issue with Chrome where this specific error occurs during navigation.
  # It seems to be a Chrome bug, and retrying once resolves the issue. 
  # If this problem occurs in other test files, consider moving this helper method to a shared helper module.
  #
  # Selenium::WebDriver::Error::UnknownError:
  # unknown error: unhandled inspector error:
  # {"code":-32000,"message":"Node with given id does not belong to the document"}
  #
  # This method retries the block once if a specific Selenium WebDriver error occurs.
  # The error is caused by a Chrome bug, and retrying once usually resolves it.
  private def retry_on_error
    return yield if !chrome_driver?
    message = '{"code":-32000,"message":"Node with given id does not belong to the document"}'
    retry_once_for(Selenium::WebDriver::Error::UnknownError, message:) { yield }
  end

  # This method retries the block once if a specified exception class occurs with a matching error message.
  # If the error occurs again or the message does not match, the error is raised.
  private def retry_once_for(exception_class, message:)
    count = 0
    yield
  rescue exception_class => e
    if count.zero? && (!message || message.in?(e.message))
      count += 1
      retry
    else
      puts e.message
      raise
    end
  end
end
