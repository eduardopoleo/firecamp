require 'spec_helper'

describe InvitationsController do
  context 'with logged in user' do
    let(:rich) {Fabricate(:admin)}
    before do
      request.env["HTTP_REFERER"] = "http://fake.host"
      session[:user_id] = rich.id
    end

    describe "Post create" do
      context 'with valid input' do
        it 'redirects back' do
          group1 = Fabricate(:group)
          group2 = Fabricate(:group)
          post :create, invitation: {email: 'rich@gmail.com', group_ids: ["1", "2", ""]}
          expect(response).to redirect_to "http://fake.host"
        end

        it 'creates an invitation' do
          group1 = Fabricate(:group)
          group2 = Fabricate(:group)
          post :create, invitation: {email: 'rich@gmail.com', group_ids: ["1", "2", ""]}
          expect(Invitation.count).to eq(1)
        end

        it 'sets invitation token' do
          group1 = Fabricate(:group)
          group2 = Fabricate(:group)
          post :create, invitation: {email: 'rich@gmail.com', group_ids: ["1", "2", ""]}
          expect(Invitation.first.token).not_to be_nil
        end

        it "creates an invitation contaning the new member's groups" do
          group1 = Fabricate(:group)
          group2 = Fabricate(:group)
          post :create, invitation: {email: 'rich@gmail.com', group_ids: ["1", "2", ""]}
          expect(Invitation.first.groups.to_a).to eq([group1, group2])
        end

        it 'sends the email containing the link to the user email' do
          group1 = Fabricate(:group)
          group2 = Fabricate(:group)
          post :create, invitation: {email: 'rich@gmail.com', group_ids: ["1", "2", ""]}
          expect(ActionMailer::Base.deliveries.last.to).to eq(['rich@gmail.com'])
          ActionMailer::Base.deliveries.clear
        end

        it 'does not create invitation without admin' do 
          juan = Fabricate(:user)
          session[:user_id] = juan.id
          group1 = Fabricate(:group)
          group2 = Fabricate(:group)
          post :create, invitation: {email: 'rich@gmail.com', group_ids: ["1", "2", ""]}
          expect(Invitation.count).to eq(0)
        end
      end

      it 'does not create invitation without email' do
        group1 = Fabricate(:group)
        group2 = Fabricate(:group)
        post :create, invitation: {email: '', group_ids: ["1", "2", ""]}
        expect(Invitation.count).to eq(0)
      end

      it 'does not create invitation without groups assigned' do
        group1 = Fabricate(:group)
        group2 = Fabricate(:group)
        post :create, invitation: {email: 'rich@gmail.com', group_ids: [""]}
        expect(Invitation.count).to eq(0)
      end 

      it 'redirects back' do
        group1 = Fabricate(:group)
        group2 = Fabricate(:group)
        post :create, invitation: {email: '', group_ids: ["1", "2", ""]}
        expect(response).to redirect_to "http://fake.host"
      end

      it 'sets the invitation intace variable' do
        group1 = Fabricate(:group)
        group2 = Fabricate(:group)
        post :create, invitation: {email: 'rich@gmail.com', group_ids: ["1"]}
        expect(assigns(:invitation)).to eq(Invitation.first)
      end
    end
  end

  context 'with no logged in user' do
    describe 'Get expired_invitation' do
      it 'renders the expired invitation template' do 
        get :expired_invitation
        expect(response).to render_template :expired_invitation
      end
    end

    it 'redirects to the root path if there is not user logged in' do
      post :create, invitation: {email: 'rich@gmail.com', group_ids: ["1"]}
      expect(assigns(response)).to redirect_to root_path
    end
  end
end
