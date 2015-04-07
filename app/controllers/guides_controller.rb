class GuidesController < ApplicationController
  before_action :require_user

  def index
    @group = Group.find(params[:group_id])
    @guides = @group.guides.to_a 
    @guide = @group.guides.build
  end

  def create
    @group = Group.find(params[:group_id])
    @guide = @group.guides.build(guide_params.merge!(admin: current_user))
    if @guide.save
      redirect_to group_guide_path(@group, @guide)
    else
      render :index
    end
  end

  def show
    @guide = Guide.find(params[:id])
  end

  private

  def guide_params
    params.require(:guide).permit(:title, :description, :content, :category)
  end
end
