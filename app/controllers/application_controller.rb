class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_user, :loggedin?, :current_vote, :number_of_likes

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def loggedin?
    !!current_user
  end

  def require_user
    if !loggedin?
      flash[:error] = "You need to log in to access that"
      redirect_to root_path
    end
  end

  def set_new_invitation
    @invitation = Invitation.new
  end

  def require_admin
    if !current_user.admin
      flash[:error] = "Sorry but you need admin privileges to do that!"
      redirect_to root_path
    end
  end

  def require_membership
    group = Group.find(params[:group_id])
    if !group.users.include?(current_user)
      redirect_to groups_path
    end
  end

  def current_vote(post, user)
    Vote.where(user: user, voteable: post).first
  end

  def number_of_likes(post)
    likes = post.votes.where(vote: true).size
    if likes > 0 
      "#{likes} likes"
    else
      ""
    end
  end
end
