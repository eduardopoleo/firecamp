class PasswordResetsController < ApplicationController
  def show
   user = User.where(token: params[:id]).first
    if user
      @token = user.token
    else
      redirect_to expired_token_path
    end
  end

  def create
    user = User.where(token: params[:token]).first
    if user
      user.password = params[:password]
      user.token = SecureRandom.urlsafe_base64
      user.save
      flash[:notice] = "Your password has been reset"
      redirect_to root_path
    else
      redirect_to expired_token_path
    end
  end

  def expired_token; end
end
