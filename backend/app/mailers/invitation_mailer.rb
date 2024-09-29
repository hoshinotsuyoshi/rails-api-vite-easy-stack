class InvitationMailer < ApplicationMailer
  def invite(user)
    @user = user
    @signed_id = user.signed_id(purpose: :invite, expires_in: 1.hour)
    mail to: user.email_address
  end
end
