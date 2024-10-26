class InvitationMailer < ApplicationMailer
  def invite(user_email_id)
    @user_email = UserEmail.find(user_email_id)
    @signed_id = @user_email.signed_id(purpose: :invite, expires_in: 1.hour)
    mail to: @user_email.email
  end
end
