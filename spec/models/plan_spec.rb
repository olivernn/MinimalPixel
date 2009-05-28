require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Plan do
  before(:each) do
    @valid_attributes = {
      :id => 1,
      :name => "Pro",
      :price => 19.95,
      :payment_frequency => "Month",
      :available => true,
      :description => "This plan is perfect for the professional user",
      :project_limit => 99,
      :image_limit => 999,
      :video_limit => 999,
      :created_at => Time.now,
      :updated_at => Time.now
    }
    @plan = Plan.new
  end

  it "should create a new instance given valid attributes" do
    Plan.create!(@valid_attributes)
  end
  
  it "should be invalid without a name" do
    @plan.attributes = @valid_attributes.except(:name)
    @plan.should_not be_valid
  end
  
  it "should be invalid without a price" do
    @plan.attributes = @valid_attributes.except(:price)
    @plan.should_not be_valid
  end
  
  it "must have a number for a price" do
    @plan.attributes = @valid_attributes.except(:price)
    @plan.price = "BLAH!@"
    @plan.should_not be_valid
  end
    
  it "should be invalid without a payment_frequency" do
    @plan.attributes= @valid_attributes.except(:payment_frequency)
    @plan.should_not be_valid
  end
  
  it "should be invalid without a payment_frequency of either 'Day', 'Week', 'Month' or 'Year'" do
    @plan.attributes = @valid_attributes.except(:payment_frequency)
    @plan.payment_frequency = "BLAH!@"
    @plan.should_not be_valid
  end
  
  it "should be invalid without availability being set" do
    @plan.attributes = @valid_attributes.except(:available)
    @plan.should_not be_valid
  end
  
  it "should be invalid without a project limit" do
    @plan.attributes = @valid_attributes.except(:project_limit)
    @plan.should_not be_valid
  end
  
  it "should be invalid without a numeric project limit" do
    @plan.attributes = @valid_attributes.except(:project_limit)
    @plan.project_limit = "BLAH!"
    @plan.should_not be_valid
  end
  
  it "should be invalid without an image limit" do
    @plan.attributes = @valid_attributes.except(:image_limit)
    @plan.should_not be_valid
  end
  
  it "should be invalid without a numeric image limit" do
    @plan.attributes = @valid_attributes.except(:image_limit)
    @plan.project_limit = "BLAH!"
    @plan.should_not be_valid
  end
  
  it "should be invalid without a video limit" do
    @plan.attributes = @valid_attributes.except(:video_limit)
    @plan.should_not be_valid
  end
  
  it "should be invalid without a numeric video limit" do
    @plan.attributes = @valid_attributes.except(:video_limit)
    @plan.project_limit = "BLAH!"
    @plan.should_not be_valid
  end
  
  it "should be invalid without a description" do
    @plan.attributes = @valid_attributes.except(:description)
    @plan.should_not be_valid
  end
  
  it "should be invalid with a description of length less than 35 characters" do
    @plan.attributes = @valid_attributes.except(:description)
    @plan.description = ""
    34.times { @plan.description << "x"} # having a description of 34 chars
    @plan.should_not be_valid
  end
  
  it "should be invalid with a description greater than 60 characters" do
    @plan.attributes = @valid_attributes.except(:description)
    @plan.description = ""
    61.times { @plan.description << "x"} # having a description of 61 chars
    @plan.should_not be_valid
  end
  
  it "should have an available named scope" do
    Plan.offerable.proxy_options.should == {:conditions => {:available => true}}
  end
  
  it "should get all chargeable accounts" do
    Plan.chargeable.proxy_options.should == {:conditions => 'price > 0'}
  end
  
  it "should not be free if the price is greater than 0" do
    @plan.attributes = @valid_attributes
    @plan.free?.should == false
  end
  
  it "should be free if the price is zero" do
    @plan.attributes = @valid_attributes.except(:price)
    @plan.price = 0
    @plan.free?.should == true
  end
end
