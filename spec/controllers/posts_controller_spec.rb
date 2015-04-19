require 'spec_helper'

describe PostsController do
  let(:user) {Fabricate(:user)}
  let(:group) {Fabricate(:group, users: [user])}
  before {session[:user_id] = user.id}



  describe 'GET index' do
    it 'renders the index template' do
      get :index, group_id: group.id 
      expect(response).to render_template :index
    end

    it 'sets the posts variables' do
      post1 = Fabricate(:post, group: group)
      post2 = Fabricate(:post, group: group)
      get :index, group_id: group.id 
      expect(assigns(:posts).to_a).to eq([post2, post1])
    end

    it 'sets a new instance of post' do
      get :index, group_id: group.id 
      expect(assigns(:post)).to be_a_new(Post)
    end 

    it 'sets the new invitation instance variable' do
      get :index, group_id: group.id 
      expect(assigns(:invitation)).to be_a_new(Invitation)
    end
  end

  describe 'Post create' do
    context 'with valid input' do
      before do
        post :create,
          group_id: group.id,
          post: Fabricate.attributes_for(:post, group: group)
      end

      it 'redirects to the index action' do
        expect(response).to redirect_to group_posts_path
      end

      it 'creates a post' do
        expect(Post.count).to eq(1)
      end

      it 'creates a post associated with the group' do
        expect(Post.first.group).to eq(group)
      end

      it 'creates a post associated with the user' do
        expect(Post.first.user).to eq(user)
      end

      it 'sets a flash message' do
        expect(flash[:success]).to be_present
      end
    end

    context 'with invalid input' do
      it 'renders the index action' do
        post :create,
          group_id: group.id,
          post: Fabricate.attributes_for(:post, group: group, content: '')
        expect(response).to render_template :index
      end

      it 'does not create a post' do
        post :create, 
          group_id: group.id,
          post: Fabricate.attributes_for(:post, group: group, content: '')
        expect(Post.count).to eq(0)
      end

      it 'sets the group variable' do
        post :create,
          group_id: group.id,
          post: Fabricate.attributes_for(:post, group: group, content: '')
        expect(assigns(:group)).to eq(group)
      end

      it 'sets the post variable' do
        post :create,
          group_id: group.id,
          post: Fabricate.attributes_for(:post, group: group, content: '')
        expect(assigns(:post)).to be_a_new(Post)
      end
    end
  end
end
