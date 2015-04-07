require 'spec_helper'

describe GuidesController do
  let(:group) {Fabricate(:group)}

  context 'with logged in user' do
    let(:rich) {Fabricate(:admin)}
    before{session[:user_id] = rich.id}

    describe 'Get index' do
      it 'renders the index template' do
        get :index, group_id: group.id
        expect(response).to render_template :index
      end

      it 'sets a new guide instance variable' do
        get :index, group_id: group.id
        expect(assigns(:guide)).to be_a_new(Guide)
      end

      it 'sets the guides instances variables only with guides associated with the group' do
        guide1 = Fabricate(:guide, group: group)
        guide2 = Fabricate(:guide, group: group)
        3.times{guide3 = Fabricate(:guide)}
        get :index, group_id: group.id
        expect(assigns(:guides)).to eq([guide2, guide1])
      end
    end

    describe 'Post create' do
      context 'with valid input' do
        before{post :create, group_id: group.id, guide: Fabricate.attributes_for(:guide)}

        it 'redirects to the guide show page' do
          expect(response).to redirect_to group_guide_path(group, Guide.first)
        end
        
        it 'sets the group instance variable' do
          expect(assigns(:group)).to eq(group)
        end

        it 'creates a guide' do
          expect(Guide.count).to eq(1)
        end

        it 'sets the guide group' do
          expect(Guide.first.group).to eq(group)
        end

        it 'sets the guide user' do
          expect(Guide.first.admin).to eq(rich)
        end
      end

      context 'with invalid input' do
        it 'renders the guides index page' do
          post :create, group_id: group.id, guide: Fabricate.attributes_for(:guide, content: "")
          expect(response).to render_template :index
        end

        it 'does not create a guide without proper title' do
          post :create, group_id: group.id, guide: Fabricate.attributes_for(:guide, content: "")
          expect(Guide.count).to eq(0)
        end

        it 'does not create a guide without proper content' do
          post :create, group_id: group.id, guide: Fabricate.attributes_for(:guide, title: "")
          expect(Guide.count).to eq(0)
        end

        it 'sets the guide instance variable' do
          post :create, group_id: group.id, guide: Fabricate.attributes_for(:guide, title: "")
          expect(assigns(:guide)).to be_a_new(Guide)
        end
      end
    end
    
    describe 'Get Show action' do
      let(:guide) {Fabricate(:guide)}
      before{get :show, group_id: group.id, id: guide.id}

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
      get :index, group_id: group.id
      expect(response).to redirect_to root_path
    end
  end
end
