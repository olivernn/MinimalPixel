require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Theme do
  before(:each) do
    @valid_attributes = {
      :name => 'dark',
      :border_colour => '#000000',
      :background_colour => '#ffffff',
      :available => true
    }
    @theme = Theme.new
  end

  it "should create a new instance given valid attributes" do
    Theme.create!(@valid_attributes)
  end
  
  it "should be invalid without a name" do
    @theme.attributes = @valid_attributes.except(:name)
    @theme.should_not be_valid
  end
  
  it "should have a unique name" do
    @theme.attributes = @valid_attributes
    @theme.save!
    @another_theme = Theme.new(@valid_attributes)
    @another_theme.should_not be_valid
  end
  
  it "should be invalid without a border colour" do
    @theme.attributes = @valid_attributes.except(:border_colour)
    @theme.should_not be_valid
  end
  
  it "should have a valid hex colour value for border colour" do
    @theme.attributes = @valid_attributes.except(:border_colour)
    ["not valid", "123456", "#GGGGGG", "#a1a1a1a"].each do |invalid_border_colour|
      @theme.border_colour = invalid_border_colour
      @theme.should_not be_valid
    end
  end
  
  it "should have a valid hex colour value for background colour" do
    @theme.attributes = @valid_attributes.except(:background_colour)
    ["not valid", "123456", "#GGGGGG", "#a1a1a1a"].each do |invalid_background_colour|
      @theme.background_colour = invalid_background_colour
      @theme.should_not be_valid
    end
  end
  
  it "should return an array of rgb for the background colour" do
    @theme.attributes = @valid_attributes
    @theme.background_colour_rgb.class.should eql(Array)
    @theme.background_colour_rgb.size.should eql(3)
  end
  
  it "should have many styles" do
    association = Theme.reflect_on_association(:styles)
    association.should_not be_nil
    association.macro.should eql(:has_many)
  end
  
  it "should have an available named_scope on available attribute" do
    Theme.available.proxy_options.should == {:conditions => {:available => true}}
  end
  
  it "should be able to return a random available theme" do
    
end
