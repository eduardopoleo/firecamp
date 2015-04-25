class WelcomeController < ApplicationController
  def landing_page
    session.clear
    if loggedin?
      redirect_to groups_path
    end
  end
end
