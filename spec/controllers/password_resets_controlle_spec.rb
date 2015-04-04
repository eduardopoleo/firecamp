require 'spec_helper'

describe PasswordResetsController do
  describe "Get Show" do
    context "with valid token" do
      it "sets the token variable" do
        alice = Fabricate(:user)
        get :show, id: alice.token
        expect(assigns(:token)).to eq(alice.token)
      end

      it 'renders the show template' do
        alice = Fabricate(:user)
        get :show, id: alice.token
        expect(response).to render_template :show
      end
    end

    context 'with invalid token' do
      it 'redirects to the expired_token path' do
        get :show, id: 'kjflkasjfieori'
        expect(response).to redirect_to expired_token_path
      end
    end
  end

  describe "Post Create" do
    context 'with valid token' do
      it 'redirects to the root_path' do
        alice = Fabricate(:user)
        post :create, token: alice.token, password: 'new_password'
        expect(response).to redirect_to root_path
      end

      it 'changes the password the password' do
        alice = Fabricate(:user)
        post :create, token: alice.token, password: 'new_password'
        expect(alice.reload.authenticate('new_password')).to be_truthy
      end

      it 'sets a flash notice' do
        alice = Fabricate(:user)
        post :create, token: alice.token, password: 'new_password'
        expect(flash[:notice]).to be_present
      end
    end

    context 'with invalid token' do
      it 'redirects to the expired token path' do
        post :create, token: 'dlskfjsa', password: 'new_password'
        expect(response).to redirect_to expired_token_path
      end
    end
  end

  describe 'Get expire_token' do
    it 'renders the expired token template' do
      get :expired_token
      expect(response).to render_template :expired_token
    end
  end
end
