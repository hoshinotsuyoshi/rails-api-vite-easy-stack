require 'rails_helper'

RSpec.describe "SPA Navigation", type: :system do
  include ActiveJob::TestHelper

  before do
    driven_by(:headless_chrome)
  end
  let!(:email) { "#{SecureRandom.uuid}@example.net" }

  it 'displays the login page' do
    visit '/login'

    # Adjust these selectors based on your actual HTML structure
    expect(page).to have_content('Login') # Or another identifier to confirm that the SPA is loading the login page
    click_link 'Create an account'

    expect(page).to have_content('Signup')
    fill_in "email", with: email
    click_button "Sign up"

    sleep 1
    perform_enqueued_jobs(only: ActionMailer::MailDeliveryJob)
    sleep 1
    mail_message = ActionMailer::Base.deliveries.sole
    url = URI.parse(extract_a_href_from_message(mail_message:))
    visit url.request_uri

    expect(page).to have_content('Email verification successful!')
    expect(page).not_to have_content('Email verification successful!')
  end

  private def extract_a_href_from_message(mail_message:)
    doc = Nokogiri::HTML(mail_message.body.raw_source)
    a_tags = doc.css('a')
    a_tags.sole.attribute_nodes.select { _1.name == "href" }.sole.value
  end
end
