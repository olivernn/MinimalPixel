require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Profile do
  before(:each) do
    @valid_attributes = {
      :user_id => 1,
      :location => "London",
      :phone => "07811140700",
      :web => "http://www.poo.com"
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
  
  it "should be invalid without a valid url" do
    @profile.attributes = @valid_attributes.except(:web)
    @profile.should be_valid
    @profile.web = "in valid web address"
    @profile.should_not be_valid
  end
end
