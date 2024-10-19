require 'rails_helper'

RSpec.describe "sign up flow", type: :system do
  include ActiveJob::TestHelper

  let!(:email) { "#{SecureRandom.uuid}@example.net" }

  it 'signup -> mail verification -> set password' do
    visit '/login'

    expect(page).to have_content('Login')
    click_link 'Create an account'

    expect(page).to have_content('Signup')
    fill_in "email", with: email
    expect(ActionMailer::Base.deliveries).to be_empty
    click_button "Sign up"
    expect(page).to have_content('Inviting')

    perform_enqueued_jobs(only: ActionMailer::MailDeliveryJob)
    mail_message = ActionMailer::Base.deliveries.sole
    url = URI.parse(extract_a_href_from_message(mail_message:))
    visit url.request_uri

    expect(page).to have_content('Email verification successful!')
    expect(page).not_to have_content('Email verification successful!')
    expect(page).to have_content('New Password')
    expect(page).to have_content('Confirm Password')
    password = SecureRandom.alphanumeric
    fill_in "password", with: password
    fill_in "confirmPassword", with: password
    click_button "Set Password"
    expect(page).to have_content("hello, It's me!")
    expect(page).to have_content(email)
  end

  private def extract_a_href_from_message(mail_message:)
    doc = Nokogiri::HTML(mail_message.body.raw_source)
    a_tags = doc.css('a')
    a_tags.sole.attribute_nodes.select { _1.name == "href" }.sole.value
  end
end
