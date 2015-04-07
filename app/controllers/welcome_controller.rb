class WelcomeController < ApplicationController
  def landing_page
    if loggedin?
      redirect_to groups_path
    end
  end
end
