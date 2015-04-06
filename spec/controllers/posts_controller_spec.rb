require 'spec_helper'

describe PostsController do
  describe 'Get index' do
    let(:group) {Fabricate(:group)}

    context 'with logged in user' do
      let(:rich) {Fabricate(:user)}
      before do
        session[:user_id] = rich.id
      end

      it 'renders the index template' do
        get :index, group_id: group.id
        expect(response).to render_template :index
      end
      
      it 'sets the @group variable' do
        get :index, group_id: group.id
        expect(assigns(:group)).to eq(group)
      end

      it 'sets the posts variable' do
        post1 = Fabricate(:post, group: group, title: 'Firt post')
        post2 = Fabricate(:post, group: group)
        get :index, group_id: group.id
        expect(assigns(:posts)).to eq([post2, post1])
      end 
    end

    context 'with no logged in user' do
      it 'redirects to the root_path' do
        get :index, group_id: group.id
        expect(response).to redirect_to root_path
      end
    end
  end

  describe "Post Create" do
    let(:group) {Fabricate(:group)}

    context 'with logged in user' do
      let (:rich) {Fabricate(:user)}
      before do
        session[:user_id] = rich.id
      end
      context 'with valid input' do
        it 'redirects index action' do
          post :create, group_id: group.id, post: Fabricate.attributes_for(:post, group: group)
          expect(response).to redirect_to(group_posts_path)
        end

        it 'creates a post' do
          post :create, group_id: group.id, post: Fabricate.attributes_for(:post, group: group)
          expect(Post.count).to eq(1)
        end

        it 'creates a post related to a group' do
          post :create, group_id: group.id, post: Fabricate.attributes_for(:post, group: group)
          expect(Post.first.group).to eq(group)
        end

        it 'creates a post related to the current user' do
          post :create, group_id: group.id, post: Fabricate.attributes_for(:post, group: group)
          expect(Post.first.user).to eq(rich)
        end

        it 'sets the group instace variable' do
          post :create, group_id: group.id, post: Fabricate.attributes_for(:post, group: group)
          expect(assigns(:group)).to eq(group)
        end
        
        it 'sets a flash message' do
          post :create, group_id: group.id, post: Fabricate.attributes_for(:post, group: group)
          expect(flash[:success]).to be_present
        end
      end

      context 'with invalid input' do
        it 'does not create a post without content' do
          post :create, group_id: group.id, post: Fabricate.attributes_for(:post, group: group, content: "")
          expect(Post.count).to eq(0)
        end

        it 'does not create a post with content smaller than 2 characters' do
          post :create, group_id: group.id, post: Fabricate.attributes_for(:post, group: group, content: "s")
          expect(Post.count).to eq(0)
        end

        it 'renders the page' do
          post :create, group_id: group.id, post: Fabricate.attributes_for(:post, group: group, content: "s")
          expect(response).to render_template :index
        end
      end
    end

    context 'with no logged in user' do
      it 'redirects to the root path if there is no user logged in' do
        post :create, group_id: group.id, post: Fabricate.attributes_for(:post, group: group, content: "s")
        expect(response).to redirect_to root_path
      end
    end
  end
end
