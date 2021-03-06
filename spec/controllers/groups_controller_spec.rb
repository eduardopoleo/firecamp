require 'spec_helper'

describe GroupsController do
  describe "get index" do
    it 'renders the index template' do
      rich = Fabricate(:user)
      session[:user_id] = rich.id
      get :index
      expect(response).to render_template :index
    end

    it 'sets a new group variable' do
      rich = Fabricate(:user)
      session[:user_id] = rich.id
      get :index
      expect(assigns(:group)).to be_a_new(Group)
    end

    it 'Sets the groups variables to the groups the current user' do
      rich = Fabricate(:user)
      session[:user_id] = rich.id
      group1 = Fabricate(:group, users: [rich])
      group2 = Fabricate(:group, users: [rich])
      4.times{Fabricate(:group)}
      
      get :index
      expect(assigns(:groups)).to match_array([group1, group2])
    end

    it 'redirects to the home path with not user signed in' do
      get :index
      expect(response).to redirect_to root_path
    end

    it 'sets a flash message when there is not users signed in' do
      get :index
      expect(flash[:error]).to be_present
    end
  end

  describe 'Post create' do
    it 'sets the group instace variable' do
      rich = Fabricate(:admin)
      session[:user_id] = rich.id 
      post :create, group:{name: 'Coffeeco Downtown', description: "MS group administration"}
      expect(assigns(:group)).to eq(Group.first)
    end
    
    context 'with valid input' do
      it 'sets a flash message when the group is created' do
        rich = Fabricate(:admin)
        session[:user_id] = rich.id
        post :create, group: Fabricate.attributes_for(:group)
        expect(flash[:success]).to be_present
      end

      it 'redirects to the post show page' do
        rich = Fabricate(:admin)
        session[:user_id] = rich.id
        post :create, group:{name: 'Coffeeco Downtown', description: "MS group administration"}
        expect(response).to redirect_to groups_path 
      end

      it 'creates a group' do
        rich = Fabricate(:admin)
        session[:user_id] = rich.id 
        post :create, group:{name: 'Coffeeco Downtown', description: "MS group administration"}
        expect(Group.count).to eq(1)
      end

      it 'creates a group associated with the admin' do
        rich = Fabricate(:admin)
        session[:user_id] = rich.id
        post :create, group:{name: 'Coffeeco Downtown', description: "MS group administration"}
        expect(Group.first.users.first).to eq(rich)
        expect(Group.first.users.first.admin).to be_truthy
      end
    end

    context 'invalid input' do
      it 'does not create the group without description' do
        rich = Fabricate(:admin)
        session[:user_id] = rich.id
        post :create, group:{name: 'Coffeeco Downtown', description: ""}
        expect(Group.count).to eq(0)
      end

      it 'does not create the group without name' do
        rich = Fabricate(:admin)
        session[:user_id] = rich.id
        post :create, group:{name: '', description: "MS group administration"}
        expect(Group.count).to eq(0)
      end

      it 'renders the group index page if the group can not be created' do
        rich = Fabricate(:admin)
        session[:user_id] = rich.id
        post :create, group:{name: 'Coffeeco Downtown', description: ""}
        expect(response).to render_template :index
      end

      it 'sets the groups instance variable' do
        rich = Fabricate(:admin)
        session[:user_id] = rich.id
        group1 = Fabricate(:group, users: [rich])
        group2 = Fabricate(:group, users: [rich])
        4.times{Fabricate(:group)}
      
        post :create, group:{name: 'Coffeeco Downtown', description: ""}
        expect(assigns(:groups)).to eq([group1, group2])
      end
    end

    it 'does not create a group without admin' do
      john = Fabricate(:user)
      session[:user_id] = john.id
      post :create, group: {name: 'Coffeeco Downtown', description: "MS group administration"}
      expect(Group.count).to eq(0)
    end
  end
end
