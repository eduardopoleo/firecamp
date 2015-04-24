require 'spec_helper'

describe UsersController do
  describe 'Get Index' do
    it 'renders the index template' do
      group = Fabricate(:group)
      get :index, group_id: group.id
      expect(response).to render_template :index
    end

    it 'sets the members instance variables' do
      group = Fabricate(:group)
      user1 = Fabricate(:user, groups: [group])
      get :index, group_id: group.id
      expect(assigns(:members)).to eq([User.first, user1])
    end
  end

  describe 'Get New' do
    it 'renders the new registration form' do
      get :new
      expect(response).to render_template :new
    end

    it 'sets the new users variables' do
      get :new
      expect(assigns(:user)).to be_a_new User
    end
  end

  describe 'Get Show' do 
    it 'renders the show template' do
      rich = Fabricate(:user)
      session[:user_id] = rich
      get :show, id: rich.id
      expect(response).to render_template :show
    end

    it 'sets the user instance variable' do
      rich = Fabricate(:user)
      session[:user_id] = rich
      get :show, id: rich.id
      expect(assigns(:user)).to eq(rich)
    end
  end

  describe 'Post create' do
    context 'with valid user signup' do
      before do
        #If we did not need the @user to be created we could have just 
        #stub the methods in the user sign up 
        customer = double('customer', successful?: true)
        StripeWrapper::Customer.stub(:create).and_return(customer)
        post :create, 
          user: Fabricate.attributes_for(:user),
          stripeToken: '345'
      end

      it 'redirects to the groups path page' do
        expect(response).to redirect_to groups_path
      end

      it 'sets a success flash message' do
        expect(flash[:success]).to be_present
      end

      it 'sets the session user_id' do
        expect(session[:user_id]).to eq(User.first.id)
      end
    end

    context 'with invalid user sign up' do
      before do
        customer = double('customer', successful?: false, error_message: "Some bad message")
        StripeWrapper::Customer.stub(:create).and_return(customer)
        post :create, 
          user: Fabricate.attributes_for(:user),
          stripeToken: '345'
      end

      it 'renders the template' do
        expect(response).to render_template :new
      end

      it 'sets a flash message cotaining the error' do
        expect(flash[:error]).to be_present
      end
       
      it 'renders the @users variables with validatation errors' do
        expect(assigns(:user)).to be_present
      end
    end
  end


  describe 'Get edit' do
    it 'render the edit user page' do
      rich = Fabricate(:user)
      session[:user_id] = rich.id
      get :edit, id: rich.id  
      expect(response).to render_template :edit
    end

    it 'sets the user variable with the current user information' do
      rich = Fabricate(:user)
      session[:user_id] = rich.id
      get :edit, id: rich.id  
      expect(assigns(:user)).to eq(rich)
    end

    it 'redirects to the root path if user is not signed up' do
      rich = Fabricate(:user)
      get :edit, id: rich.id  
      expect(response).to redirect_to root_path
    end
  end

  describe 'Post update' do
    it 'redirects to the user show page if successful' do
      rich = Fabricate(:user, email: 'some@gmail.com')
      session[:user_id] = rich.id
      post :update, id: rich.id, user: Fabricate.attributes_for(:user, email: 'another@gmail.com')
      expect(response).to redirect_to user_path(rich) 
    end
    
    it 'updates the user info' do
      rich = Fabricate(:user, email: 'some@gmail.com')
      session[:user_id] = rich.id
      post :update, id: rich.id, user: Fabricate.attributes_for(:user, email: 'another@gmail.com')
      expect(rich.reload.email).to eq('another@gmail.com')
    end

    it 'sets as flash message' do
      rich = Fabricate(:user, email: 'some@gmail.com')
      session[:user_id] = rich.id
      post :update, id: rich.id, user: Fabricate.attributes_for(:user, email: 'another@gmail.com')
      expect(flash[:success]).to be_present
    end

    it 'does not update the user if validation are not passed' do
      rich = Fabricate(:user, email: 'some@gmail.com')
      session[:user_id] = rich.id
      post :update, id: rich.id, user: Fabricate.attributes_for(:user, email: '')
      expect(rich.reload.email).to eq('some@gmail.com')
    end

    it 'renders the edit template if the update does not pass validation' do
      rich = Fabricate(:user, email: 'some@gmail.com')
      session[:user_id] = rich.id
      post :update, id: rich.id, user: Fabricate.attributes_for(:user, email: '')
      expect(response).to render_template :edit
    end

    it 'sets the user instance variable' do
      rich = Fabricate(:user, email: 'some@gmail.com')
      session[:user_id] = rich.id
      post :update, id: rich.id, user: Fabricate.attributes_for(:user, email: '')
      expect(assigns(:user)).to eq(rich) 
    end
  end

  describe 'Get invited_user' do
    context 'with valid token' do
      let(:invitation) {Fabricate(:invitation)}
      before{get :invited_user, token: invitation.token}

      it 'renders the create user user form' do
        expect(response).to render_template :invited_user
      end

      it 'sets the new user instance variable with email equal to the invitation email' do
        expect(assigns(:user)).to be_a_new(User)
        expect(assigns(:user).email).to eq(invitation.email)
      end

      it 'sets the token instance variable' do
        expect(assigns(:invitation)).to eq(invitation)
      end
    end

    context 'with invalid token' do
      it 'redirects to the expired token path if there is no invitation associated' do
        get :invited_user, token: 'some_token'
        expect(response).to redirect_to expired_invitation_path
      end
    end
  end

  describe 'Post create_invited_user' do
    context 'with valid input' do
      let (:invitation) {Fabricate(:invitation)}
      before{post :create_invited_user, user: Fabricate.attributes_for(:user), token: invitation.token}

      it 'redirects to the group index path' do
        expect(response).to redirect_to groups_path
      end

      it 'creates an user' do
        #Invitation fab creates a group. Group fab creates an admin user.
        expect(User.count).to eq(2)
      end

      it 'creates an user associated with the invitation groups' do
        expect(User.all[1].groups[0]).to eq(invitation.groups[0])
      end

      it 'sets the invitation token attribute to nil' do
        expect(invitation.reload.token).to be_nil
      end

      it 'sets the user id in the session' do
        expect(session[:user_id]).to eq(User.all[1].id)
      end 
    end

    context 'with invalid user input' do
      it 'renders the invited user template if validation fails' do
        invitation = Fabricate(:invitation)
        post :create_invited_user, user: Fabricate.attributes_for(:user, email: " "), token: invitation.token 
        expect(response).to render_template :invited_user
      end
    end

    it 'redirects to the expired_invitation_path if there is not invitation associated with the token provided' do
      post :create_invited_user, user: Fabricate.attributes_for(:user, email: " "), token: "some_fake_token" 
      expect(response).to redirect_to expired_invitation_path
    end
  end
end
