class GroupsController < ApplicationController
  def index
    @groups = current_user.groups
  end

  def create
    group = current_user.groups.build(group_params) 
    if group.save
      flash[:success] = 'You have successfully created a group'
      redirect_to group_path(group)
    else
      render :index
    end
  end

  private
  def group_params
    params.require(:group).permit(:name, :description)
  end
end
