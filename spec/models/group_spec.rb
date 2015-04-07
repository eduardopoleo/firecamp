require 'spec_helper'

describe Group do
  it {should validate_presence_of(:name)}
  it {should validate_presence_of(:description)}
  it {should have_many(:posts)}
  it {should belong_to(:admin)}
end
