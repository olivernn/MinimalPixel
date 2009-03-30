require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Profile do
  before(:each) do
    @valid_attributes = {
      :user_id => 1,
      :location => "London",
      :phone => "07811140700",
      :web => "www.poo.com"
    }
    @profile = Profile.new
  end

  it "should create a new instance given valid attributes" do
    Profile.create!(@valid_attributes)
  end
  
  it "should belong to a user" do
    association = Profile.reflect_on_association(:user)
    association.should_not be_nil
    association.macro.should eql(:belongs_to)
  end
end
