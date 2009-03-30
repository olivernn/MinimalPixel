require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Style do
  before(:each) do
    @valid_attributes = {
      :user_id => 1,
      :heading_colour => '#ff9300',
      :border_type => 'thin',
      :theme_id => 1,
      :font_id => 2
    }
    @style = Style.new
  end

  it "should create a new instance given valid attributes" do
    @style.attributes = @valid_attributes
    @style.should be_valid
  end
  
  it "should be invalid without a heading colour" do
    @style.attributes = @valid_attributes.except(:heading_colour)
    @style.should_not be_valid
  end
  
  it "should have a valid hex colour value for heading colour" do
    @style.attributes = @valid_attributes.except(:heading_colour)
    ["not valid", "123456", "#GGGGGG", "#a1a1a1a"].each do |invalid_heading_colour|
      @style.heading_colour = invalid_heading_colour
      @style.should_not be_valid
    end
  end
  
  it "should be invalid without a border type" do
    @style.attributes = @valid_attributes.except(:border_type)
    @style.should_not be_valid
  end
  
  it "should be invalid without a supported border type" do
    @style.attributes = @valid_attributes.except(:border_type)
    @style.border_type = "unsupported"
    @style.should_not be_valid
  end
  
  it "should be valid with a supported border type" do
    @style.attributes = @valid_attributes.except(:border_type)
    ["thin", "fat", "polaroid"].each do |supported_border_type|
      @style.border_type = supported_border_type
      @style.should be_valid
    end
  end
  
  it "should belong to a user" do
    association = Style.reflect_on_association(:user)
    association.should_not be_nil
    association.macro.should eql(:belongs_to)
  end
  
  it "should belong to a theme" do
    association = Style.reflect_on_association(:theme)
    association.should_not be_nil
    association.macro.should eql(:belongs_to)
  end
  
  it "should start with some defaults" do
    @default_style = Style.default
    @default_style.should be_valid
  end
  
  it "should return an array of rgb" do
    @style.attributes = @valid_attributes
    @style.heading_colour_rgb.class.should eql(Array)
    @style.heading_colour_rgb.size.should eql(3)
  end
end
