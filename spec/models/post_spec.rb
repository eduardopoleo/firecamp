require 'spec_helper'

describe Post do
  it {should belong_to(:user)}
  it {should belong_to(:group)}
  it {should validate_presence_of(:content)}
  it {should validate_length_of(:content)}
end
