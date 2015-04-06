require 'spec_helper'

describe UsersController do
  describe 'Get NEW' do
    it 'renders the new registration form' do
      get :new
      expect(response).to render_template :new
    end

    it 'sets the new users variables' do
      get :new
      expect(assigns(:user)).to be_a_new User
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
end
