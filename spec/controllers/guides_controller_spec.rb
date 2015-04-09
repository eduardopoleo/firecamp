require 'spec_helper'

describe GuidesController do
  let(:group) {Fabricate(:group)}

  context 'with logged in user' do
    let(:rich) {Fabricate(:admin)}
    before{session[:user_id] = rich.id}

    describe 'Post create' do
      context 'with valid input' do
        before do
          request.env["HTTP_REFERER"] = "http://fake.host"
        end

        it 'redirects back' do
          group1 = Fabricate(:group)
          group2 = Fabricate(:group)
          post :create, guide: {title: 'This is some title', content: 'This is some content', group_ids: ["1", "2", ""]} 
          expect(response).to redirect_to "http://fake.host"
        end
                
        it 'creates a guide' do
          group1 = Fabricate(:group)
          group2 = Fabricate(:group)
          post :create, guide: {title: 'This is some title', content: 'This is some content', group_ids: ["1", "2", ""]} 
          expect(Guide.count).to eq(1)
        end

        it 'sets a flash message' do
          group1 = Fabricate(:group)
          group2 = Fabricate(:group)
          post :create, guide: {title: 'This is some title', content: 'This is some content', group_ids: ["1", "2", ""]} 
          expect(flash[:success]).to be_present
        end

        it 'sets the guide user' do
          group1 = Fabricate(:group)
          group2 = Fabricate(:group)
          post :create, guide: {title: 'This is some title', content: 'This is some content', group_ids: ["1", "2", ""]} 
          expect(Guide.first.admin).to eq(rich)
        end

        it 'sets the guide groups' do
          group1 = Fabricate(:group)
          group2 = Fabricate(:group)
          post :create, guide: {title: 'This is some title', content: 'This is some content', group_ids: ["1", "2", ""]} 
          expect(Guide.first.groups).to match_array([group1, group2])
        end
      end

      context 'with invalid input' do
        it 'renders the group guides page' do
          group1 = Fabricate(:group)
          group2 = Fabricate(:group)
          post :create, guide: {title: '', content: 'This is some content', group_ids: ["1", "2", ""]} 
          expect(response).to render_template 'group_guides'
        end
        
        it 'renders the group guides page' do
          group1 = Fabricate(:group)
          group2 = Fabricate(:group)
          post :create, guide: {title: '', content: 'This is some content', group_ids: ["1", "2", ""]} 
          expect(Guide.count).to eq(0)
        end

        it 'sets the guide instance variable' do
          group1 = Fabricate(:group)
          group2 = Fabricate(:group)
          post :create, guide: {title: '', content: 'This is some content', group_ids: ["1", "2", ""]} 
          expect(assigns(:guide)).to be_a_new(Guide)
        end
      end
    end
    
    describe 'Get Show action' do
      let(:guide) {Fabricate(:guide)}
      before{get :show, id: guide.id}

      it 'renders the show template' do
        expect(response).to render_template :show
      end

      it 'sets the guide instance variable' do
        expect(assigns(:guide)).to eq(guide)
      end
    end
  end

  context 'without logged in user' do
    it 'redirects to the root_path if there is no user logged in' do
      get :create, group_id: group.id
      expect(response).to redirect_to root_path
    end
  end
end
