class GroupsController < ApplicationController
  before_action :require_user
  def index
    @group = Group.new
    @groups = current_user.groups.to_a
  end

  def create
    @group = Group.new(group_params) 
    if @group.save
      @group.users << current_user
      flash[:success] = 'You have successfully created a group'
      redirect_to groups_path
    else
      @groups = current_user.groups.to_a.delete_if(&:new_record?)
      render :index
    end
  end

  private
  def group_params
    params.require(:group).permit(:name, :description)
  end
end
