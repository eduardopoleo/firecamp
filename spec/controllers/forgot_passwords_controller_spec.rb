require 'spec_helper'

describe ForgotPasswordsController do
  describe "Get New" do
    it 'renders the new password template' do
      get :new
      expect(response).to render_template :new
    end
  end

  describe "Post Create" do
    context 'with non existing email' do
      it 'redirects to the new action' do
        post :create, email: "" 
        expect(response).to redirect_to new_password_path
      end

      it 'sets a flash message containing the adequate error' do
        post :create, email: "" 
        expect(flash[:error]).to eq('Email adress field can not be blank')
      end
    end

    context 'with non existing email' do
      it 'redirects to the new action' do
        post :create, email: "jose@gmail.com" 
        expect(response).to redirect_to new_password_path
      end

      it 'sets a flash message containing the adequate error' do
        post :create, email: "jose@gmail.com" 
        expect(flash[:error]).to eq('There is not account associated with that email')
      end
    end

    context 'with valid email' do
      let(:user){Fabricate(:user)}
      before{post :create, email: user.email}

      it 'sends the email containing the link to the user email' do
        expect(ActionMailer::Base.deliveries.last.to).to eq([user.email])
        ActionMailer::Base.deliveries.clear
      end

      it 'redirect to the forgot_password_confirmation path' do
        expect(response).to redirect_to forgot_passwords_confirmation_path
      end
    end
  end
end
