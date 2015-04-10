require 'spec_helper'

describe User do
  it {should validate_presence_of(:email)}
  it {should validate_presence_of(:full_name)}
  it {should validate_presence_of(:password)}
  it {should validate_uniqueness_of(:email)}
  it {should have_secure_password}

  describe '#has_membership?' do
    it 'returns false if the user does NOT share membership with object' do
      group1 = Fabricate(:group)
      group2 = Fabricate(:group)
      post = Fabricate(:post, groups: [group2])
      user = Fabricate(:user, groups: [group1]) 
      expect(user.has_membership?(post)).not_to be_truthy 
    end

    it 'returns true if the user does share membership with object' do
      group1 = Fabricate(:group)
      group2 = Fabricate(:group)
      post = Fabricate(:post, groups: [group1, group2])
      user = Fabricate(:user, groups: [group1]) 
      expect(user.has_membership?(post)).to be_truthy 
    end
  end
end
