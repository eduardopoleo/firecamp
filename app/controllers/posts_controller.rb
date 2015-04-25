class PostsController < ApplicationController
  before_action :require_membership
  before_action :require_user
  before_action :set_new_invitation
  before_action :set_group

  def index
    @posts = @group.posts.to_a.delete_if(&:new_record?)
    @post = @group.posts.build
  end

  def create
    @post = @group.posts.build(post_params.merge!(user: current_user))
    if @post.save
      flash[:success] = 'Your post has been created'
      redirect_to group_posts_path
    else
      @posts = @group.posts.to_a.delete_if(&:new_record?)
      render :index
    end
  end

  def vote
    @post = Post.find(params[:id])
    @post_vote = current_vote(@post, current_user)

    if @post_vote
      update_vote_status(@post_vote)
    else
      @post_vote = Vote.create(user: current_user, voteable: @post)
      update_vote_status(@post_vote)
    end

    respond_to do |format|
      format.html do 
        redirect_to group_posts_path(@group)
      end 
    
      format.js
    end
  end

  private
  def post_params
    params.require(:post).permit(:title, :content)
  end

  def set_group
    @group = Group.find(params[:group_id])
  end

  def update_vote_status(vote)
    vote.vote ? vote.update_attribute(:vote, false) : vote.update_attribute(:vote, true)
  end
end
