class GuidesController < ApplicationController
  before_action :require_user
  before_action :require_membership

  def index
    @group = Group.find(params[:group_id])
    @guides = @group.guides
  end

  def create
    @group = Group.find(params[:group_id])
    @guide = @group.guides.build(guide_params.merge!(user: current_user))
    if @guide.save
      flash[:success] = "Your guide has been created."
      redirect_to group_guides_path(@group)
    else
      @guides = @group.guides.to_a.delete_if(&:new_record?)
      render :index
    end
  end

  private

  def guide_params
    params.require(:guide).permit(:title, :content, :description, :category)
  end
end
