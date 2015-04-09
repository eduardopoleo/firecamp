class PostsController < ApplicationController
  before_action :require_user

  def create
    @post = Post.new(post_params.merge!(user: current_user))
    if @post.save
      flash[:success] = 'You post has been created'
      redirect_to :back
    else
      render 'groups/group_posts'
    end
  end
   
  private
  def post_params
    params.require(:post).permit!
  end
end
