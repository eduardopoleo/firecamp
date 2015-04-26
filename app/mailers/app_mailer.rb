class AppMailer < ActionMailer::Base
  def welcome_notification(user)
    @user = user
    mail from: 'info@firecamp.ca', to: user.email, subject: "Welcome to Firecamp"
  end

  def send_forgot_password(user)
    @user = user
    mail from: 'info@firecamp.ca', to: user.email, subject: "Password reset"
  end

  def send_invitation(current_user, invitation)
    @sender = current_user
    @invitation = invitation
    mail from: 'info@firecamp.ca', to: @invitation.email, subject: "Firecamp invitation"
  end
end
