class AppMailer < ActionMailer::Base
  def welcome_notification(user)
    @user = user
    mail from: 'info@mytodoapp.com', to: user.email, subject: "You created a new todo"
  end

  def send_forgot_password(user)
    @user = user
    mail from: 'info@mytodoapp.com', to: user.email, subject: "Password reset"
  end
end
