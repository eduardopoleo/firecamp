class InvitationsController < ApplicationController
  before_action :require_user, only: [:new, :create]
  before_action :require_admin, only: [:new, :create]

  def new
    @invitation = Invitation.new
  end

  def create
    @invitation = Invitation.new(invitation_params)
    if @invitation.save
      @invitation.update_attribute(:token, SecureRandom.urlsafe_base64)
      AppMailer.send_invitation(current_user, @invitation).deliver
      redirect_to new_invitation_path
    else
      render :new
    end
  end

  def expired_invitation; end

  private
  def invitation_params
    params.require(:invitation).permit!
  end
end
