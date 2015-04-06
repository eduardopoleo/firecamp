class PostsController < ApplicationController
  before_action :require_user
  def index
    @group = Group.find(params[:group_id])
    @posts = @group.posts
  end

  def create
    @group = Group.find(params[:group_id])
    @post = @group.posts.build(post_params.merge!(user: current_user))
    if @post.save
      flash[:success] = 'You post has been created'
      redirect_to group_posts_path
    else
      render :index
    end
  end
   
  private
  def post_params
    params.require(:post).permit(:title, :content)
  end
end
