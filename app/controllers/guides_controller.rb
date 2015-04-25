class GuidesController < ApplicationController
  before_action :require_user
  before_action :require_membership
  before_action :set_new_invitation
  before_action :require_admin, only: [:create]

  def index
    @group = Group.find(params[:group_id])
    @guides = @group.guides.to_a.delete_if(&:new_record?)
    @guide = @group.guides.build
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

  def show
    @group = Group.find(params[:group_id])
    @guide = Guide.find(params[:id])
  end

  private

  def guide_params
    params.require(:guide).permit(:title, :content, :description, :category)
  end
end
