class InvitationMailer < ApplicationMailer
  def invite(user_id)
    @user = User.find(user_id)
    @signed_id = @user.signed_id(purpose: :invite, expires_in: 1.hour)
    mail to: @user.email_address
  end
end
