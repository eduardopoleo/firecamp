class InvitationsController < ApplicationController
  before_action :require_user, only: [:create]
  before_action :require_admin, only: [:create]

  def create
    @invitation = Invitation.new(invitation_params)
    if @invitation.save
      @invitation.update_attribute(:token, SecureRandom.urlsafe_base64)
      AppMailer.delay.send_invitation(current_user, @invitation)
    else
      flash[:error] = "Your invitation could not be sent. Please make sure that you have input a VALID EMAIL and selected at least ONE OF YOUR GROUPS."
    end

    respond_to do |format|
      format.html do 
        redirect_to :back
      end 

      format.js
    end

  end

  def expired_invitation; end

  private
  def invitation_params
    params.require(:invitation).permit!
  end
end
