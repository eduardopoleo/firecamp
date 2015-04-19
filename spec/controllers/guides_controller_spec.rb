require 'spec_helper'

describe GuidesController do
  describe 'Get index' do
    context 'Authenticated and member' do
      let(:user) {Fabricate(:user)} 
      let(:group) {Fabricate(:group, users: [user])}
      before {session[:user_id] = user.id}

      it 'renders the index templlte' do
        get :index, group_id: group.id
        expect(:response).to render_template :index
      end

      it 'sets the guides variables' do
        guide1 = Fabricate(:guide, group: group)
        guide2 = Fabricate(:guide, group: group)
        get :index, group_id: group.id
        expect(assigns(:guides)).to eq([guide2, guide1])
      end

      it 'sets a new invitation variable' do
        get :index, group_id: group.id
        expect(assigns(:invitation)).to be_a_new(Invitation)
      end

      it 'sets a new guide variable' do
        get :index, group_id: group.id
        expect(assigns(:guide)).to be_a_new(Guide)
      end
    end

    context 'unauthenticated user' do
      it 'redirects to the root path' do
        group = Fabricate(:group)
        get :index, group_id: group.id
        expect(:response).to redirect_to root_path
      end
    end

    context 'without membership' do
      let(:user) {Fabricate(:user)} 
      before {session[:user_id] = user.id}

      it 'redirects to the groups path' do
        group = Fabricate(:group)
        get :index, group_id: group.id
        expect(:response).to redirect_to groups_path
      end
    end
  end

  describe 'Post create' do
    let(:user) {Fabricate(:user)} 
    let(:group) {Fabricate(:group, users: [user])}
    before {session[:user_id] = user.id}

    context 'with valid input' do
      it 'redirects to the group guides path' do
        post :create,
          group_id: group.id,
          guide: Fabricate.attributes_for(:guide) 
        expect(response).to redirect_to group_guides_path(group)
      end

      it 'creates a guide' do
        post :create,
          group_id: group.id,
          guide: Fabricate.attributes_for(:guide) 
        expect(Guide.count).to eq(1)
      end

      it 'associates the group' do
        post :create,
          group_id: group.id,
          guide: Fabricate.attributes_for(:guide) 
        expect(Guide.first.group).to eq(group)
      end

      it 'associates the user' do
        post :create,
          group_id: group.id,
          guide: Fabricate.attributes_for(:guide) 
        expect(Guide.first.user).to eq(user)
      end

      it 'sets flash message' do
        post :create,
          group_id: group.id,
          guide: Fabricate.attributes_for(:guide) 
        expect(flash[:success]).to be_present
      end
    end 

    context 'With invalid input' do
      it  'renders the index template' do
        post :create,
          group_id: group.id,
          guide: Fabricate.attributes_for(:guide, title: ' ') 
        expect(response).to render_template :index
      end

      it  'sets the guide instance variable' do
        post :create,
          group_id: group.id,
          guide: Fabricate.attributes_for(:guide, title: ' ') 
        expect(assigns(:guide)).to be_a_new(Guide)
      end

      it  'sets the group instance variable' do
        post :create,
          group_id: group.id,
          guide: Fabricate.attributes_for(:guide, title: ' ') 
        expect(assigns(:group)).to eq(group)
      end
      
      it  'does not create the guide' do
        post :create,
          group_id: group.id,
          guide: Fabricate.attributes_for(:guide, title: ' ') 
        expect(Guide.count).to eq(0)
      end

      it  'sets the guides instance variable' do
        guide1 = Fabricate(:guide, group: group)
        guide2 = Fabricate(:guide, group: group)
        post :create,
          group_id: group.id,
          guide: Fabricate.attributes_for(:guide, title: ' ') 
        expect(assigns(:guides)).to eq([guide2, guide1])
      end
    end
  end

  describe 'Get show' do
    let(:user) {Fabricate(:user)} 
    let(:group) {Fabricate(:group, users: [user])}
    before {session[:user_id] = user.id}

    it 'sets the guide instance variable' do
      guide = Fabricate(:guide, group: group)
      get :show, group_id: group.id, id: guide.id
      expect(assigns(:guide)).to eq(guide)
    end

    it 'sets the group instance variable' do
      guide = Fabricate(:guide, group: group)
      get :show, group_id: group.id, id: guide.id
      expect(assigns(:group)).to eq(group)
    end
  end
end
