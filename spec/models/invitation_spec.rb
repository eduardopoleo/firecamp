require 'spec_helper'

describe Invitation do
  it {should have_many(:invitation_groups)}
  it {should validate_presence_of(:groups)}
  it {should validate_presence_of(:email)}

  describe '#add_groups_to_new user' do
    it 'should insert invitation groups into users' do
      invitation = Fabricate(:invitation, groups: [Fabricate(:group), Fabricate(:group)])
      user = Fabricate(:user)
      invitation.add_groups_to_new_user(user)
      expect(user.groups).to eq(invitation.groups)
    end
  end
end
