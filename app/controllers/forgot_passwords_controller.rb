class ForgotPasswordsController < ApplicationController
  def new; end

  def create
    @user = User.where(email: params[:email]).first
    if @user 
      AppMailer.send_forgot_password(@user).deliver
      redirect_to forgot_passwords_confirmation_path
    else
      flash[:error] = params[:email].blank? ? "Email adress field can not be blank" : "There is not account associated with that email" 
      redirect_to new_password_path
    end
  end

  def confirmation; end
end
