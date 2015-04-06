require 'spec_helper'

describe WelcomeController do
  describe 'get landing_page' do
    it 'renders the landing page view if there are not users logged in' do
      get :landing_page
      expect(response).to render_template :landing_page
    end

    it 'redirects to the user group index if there is logged in' do
      joe = Fabricate(:user)
      session[:user_id] = joe.id
      get :landing_page
      expect(response).to redirect_to groups_path
    end
  end
end
