class PostsController < ApplicationController
  before_action :require_membership
  before_action :require_user
  before_action :set_new_invitation

  def index
    @group = Group.find(params[:group_id])
    @posts = @group.posts.to_a.delete_if(&:new_record?)
    @post = @group.posts.build
  end

  def create
    @group = Group.find(params[:group_id])
    @post = @group.posts.build(post_params.merge!(user: current_user))
    if @post.save
      flash[:success] = 'Your post has been created'
      redirect_to group_posts_path
    else
      @posts = @group.posts.to_a.delete_if(&:new_record?)
      render :index
    end
  end

  private
  def post_params
    params.require(:post).permit(:title, :content)
  end
end
