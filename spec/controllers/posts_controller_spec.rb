require 'spec_helper'

describe PostsController do
  describe "Post Create" do
    context 'with logged in user' do
      let (:rich) {Fabricate(:admin)}
      before do
        request.env["HTTP_REFERER"] = "http://fake.host"
        session[:user_id] = rich.id
      end
      context 'with valid input' do
        it 'redirects back' do
          group1 = Fabricate(:group)
          group2 = Fabricate(:group)
          post :create, post: {title: 'This is some title', content: 'This is some content', group_ids: ["1", "2", ""]} 
          expect(response).to redirect_to "http://fake.host"
        end

        it 'creates a post' do
          group1 = Fabricate(:group)
          group2 = Fabricate(:group)
          post :create, post: {title: 'This is some title', content: 'This is some content', group_ids: ["1", "2", ""]} 
          expect(Post.count).to eq(1)
        end

        it 'creates a post related to various groups' do
          group1 = Fabricate(:group)
          group2 = Fabricate(:group)
          post :create, post: {title: 'This is some title', content: 'This is some content', group_ids: ["1", "2", ""]}
          expect(Post.first.groups).to eq([group1, group2])
        end

        it 'creates a post related to the current user' do
          group1 = Fabricate(:group)
          group2 = Fabricate(:group)
          post :create, post: {title: 'This is some title', content: 'This is some content', group_ids: ["1", "2", ""]}
          expect(Post.first.user).to eq(rich)
        end

        it 'sets a flash message' do
          group1 = Fabricate(:group)
          group2 = Fabricate(:group)
          post :create, post: {title: 'This is some title', content: 'This is some content', group_ids: ["1", "2", ""]}
          expect(flash[:success]).to be_present
        end
      end

      context 'with invalid input' do
        it 'does not create a post with content smaller than 2 characters' do
          group1 = Fabricate(:group)
          group2 = Fabricate(:group)
          post :create, post: {title: 'This is some title', content: '', group_ids: ["1", "2", ""]}
          expect(Post.count).to eq(0)
        end

        it 'renders the page' do
          group1 = Fabricate(:group)
          group2 = Fabricate(:group)
          post :create, post: {title: 'This is some title', content: '', group_ids: ["1", "2", ""]}
          expect(response).to render_template :group_posts
        end

        it 'does not create a post with no group associated' do
          group1 = Fabricate(:group)
          group2 = Fabricate(:group)
          post :create, post: {title: 'This is some title', content: 'dslkfskj flaksjdf', group_ids: [""]}
          expect(Post.count).to eq(0)
        end
      end

      it 'does not create post if not admin' do
        juan = Fabricate(:user)
        session[:user_id] = juan.id
        group1 = Fabricate(:group)
        post :create, post: {title: 'This is some title', content: 'dslkfskj flaksjdf', group_ids: ["1"]}
        expect(Post.count).to eq(0)
      end
    end

    context 'with no logged in user' do
      it 'redirects to the root path if there is no user logged in' do
        post :create, post: Fabricate.attributes_for(:post)
        expect(response).to redirect_to root_path
      end
    end
  end
end
