class GuidesController < ApplicationController
  before_action :require_user

  def create
    @guide = Guide.new(guide_params.merge!(admin: current_user))
    if @guide.save
      flash[:success] = 'You post has been created'
      redirect_to :back
    else
      render 'groups/group_guides'
    end
  end

  def show
    @guide = Guide.find(params[:id])
  end

  private

  def guide_params
    params.require(:guide).permit!
  end
end
