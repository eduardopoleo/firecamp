class GroupsController < ApplicationController
  before_action :require_user
  def index
    @group = Group.new
    @groups = current_user.groups
  end

  def create
    group = current_user.groups.build(group_params) 
    if group.save
      flash[:success] = 'You have successfully created a group'
      redirect_to posts_path
    else
      render :index
    end
  end

  private
  def group_params
    params.require(:group).permit(:name, :description)
  end
end
