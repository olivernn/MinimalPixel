require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Project do
  before(:each) do
    @valid_attributes = {
      :user_id => 1,
      :name => 'my project',
      :description => 'my very first project',
      :date => Date.today.to_s,
      :status => 'active',
      :created_at => Time.now,
      :updated_at => Time.now
    }
    @project = Project.new
  end

  it "should create a new instance given valid attributes" do
    Project.create!(@valid_attributes)
  end
  
  # test the validations are present on the model
  it "should be invalid without a name" do
    @project.attributes = @valid_attributes.except(:name)
    @project.should_not be_valid
  end
  
  it "should be invalid with a name longer than 20 characters" do
    @project.attributes = @valid_attributes.except(:name)
    @project.name = "This is a really reall long name, far longer than the 30 characters allowed"
    @project.should_not be_valid
  end
  
  # currently there are problems getting the date picker and the validation to work together
  # will just remove the attribute from the forms and validation altogether for now
  it "should have a valid date if date is populated" do
    @project.attributes = @valid_attributes.except(:date)
    @project.should be_valid
    @project.date = "not a date"
    @project.should_not be_valid
  end
  
  # test the different states of the project
  it "should have an initial status of draft" do
    @project.attributes = @valid_attributes.except(:status)
    @project.save
    @project.status.should eql("draft")
  end
  
  it "should have status of 'active' after being published" do
    @project.attributes = @valid_attributes.except(:status)
    @project.save
    @project.publish!
    @project.status.should eql('active')
  end
  
  it "should have status of 'deleted' after being removed" do
    @project.attributes = @valid_attributes.except(:status)
    @project.save
    @project.publish!
    @project.remove!
    @project.status.should eql('removed')
  end
  
  # making sure that the named_scopes have been included
  it "should have an active named_scope on status" do
    Project.active.proxy_options.should == {:conditions => {:status => "active"}, :order => 'created_at DESC'}
  end
  
  it "should have a removed named_scrop on status" do
    Project.removed.proxy_options.should == {:conditions => {:status => "removed"}}
  end
  
  it "should have a drafts named_scrop on status" do
    Project.drafts.proxy_options.should == {:conditions => {:status => "draft"}}
  end
  
  # prettier urls please!
  it "should have a param that includes its name" do
    @project.attributes = @valid_attributes
    @project.to_param.should eql("#{@project.id}-#{@project.name.parameterize.to_s}")
  end
  
  # testing the associations have been included
  it "should have some items" do
    association = Project.reflect_on_association(:items)
    association.should_not be_nil
    association.macro.should eql(:has_many)
  end

  it "should belong to a user" do
    association = Project.reflect_on_association(:user)
    association.should_not be_nil
    association.macro.should eql(:belongs_to)
  end
end
