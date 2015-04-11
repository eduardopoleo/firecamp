class GroupsController < ApplicationController
  before_action :require_user 
  before_action :require_admin, only: [:create]
  before_action :require_membership, only:[:group_posts, :group_guides]

  def index
    @group = Group.new
    @groups = current_user.groups.to_a
    @invitation = Invitation.new
    @post = Post.new
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

  def group_posts
    @group = Group.find(params[:group_id])
    @posts = @group.posts.order("created_at DESC")
    @post = Post.new
  end

  def group_guides
    @group = Group.find(params[:group_id])
    @guides = @group.guides.order("created_at DESC")
    @guide = Guide.new
  end

  private
  def group_params
    params.require(:group).permit(:name, :description, :group_cover)
  end
end
