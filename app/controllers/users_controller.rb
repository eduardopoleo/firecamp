class UsersController < ApplicationController
  before_action :require_user, only: [:edit]

  def new
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
  end

  def create
    @user = User.new(user_params)
    user_signup = UserSignup.new(@user).signup(params[:stripeToken])

    if user_signup.successful?
      flash[:success] = 'Welcome to Firecamp! Hope you enjoy the experience'
      session[:user_id] = @user.id
      redirect_to groups_path
    else
      flash[:error] = user_signup.error_message
      render :new
    end
  end

  def edit
    @user = User.find(params[:id]) 
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:success] = 'Your profile has been successfully updated'
      redirect_to user_path(@user)
    else
      render :edit
    end
  end

  def invited_user
    @invitation = Invitation.where(token: params[:token]).first
    if @invitation
      @user = User.new(email: @invitation.email)
      render :invited_user
    else
      redirect_to expired_invitation_path
    end
  end

  def create_invited_user
    @invitation = Invitation.where(token: params[:token]).first

    if @invitation
      @user = User.new(user_params)
      if @user.save
        @invitation.add_groups_to_new_user(@user)
        session[:user_id] = @user.id
        redirect_to groups_path
      else
        render :invited_user
      end
    else
      redirect_to expired_invitation_path
    end
  end

  private
  def user_params
    params.require(:user).permit(:full_name, :email, :password, :avatar)
  end
end
