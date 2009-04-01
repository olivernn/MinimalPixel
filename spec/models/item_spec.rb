require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Item do
  before(:each) do
    @valid_attributes = {
      :id => 1,
      :project_id => 1,
      :position => 1,
      :name => 'my amazing piece of art',
      :description => 'my very painting',
      :date => Date.today.to_s,
      :type => 'image', # have to pretend that this is an image item
      :created_at => Time.now,
      :updated_at => Time.now
    }
    @item = Item.new
  end
  
  it "should be invalid without a name" do
    @item.attributes = @valid_attributes.except(:name)
    @item.should_not be_valid
  end
  
  it "should have a valid date if date is populated" do
    @item.attributes = @valid_attributes.except(:date)
    @item.date = "not a date"
    @item.should_not be_valid
  end
  
  # test that the associations are as they should be
  it "should belong to a project" do
    association = Item.reflect_on_association(:project)
    association.should_not be_nil
    association.macro.should == :belongs_to
  end
  
  it "should have a param that includes its name" do
    @item.attributes = @valid_attributes
    @item.to_param.should eql("#{@item.id}_#{@item.name.parameterize.to_s}")
  end
  
  # trying to test some of the list actions, having to create images as otherwise we cannot set the type
  # attribute which is required by the database!
  it "should be ordered by position" do
    @first_item = Image.create(@valid_attributes)
    @second_item = Image.create(@valid_attributes)
    Item.find(:all).first.position.should eql(1)
    Item.find(:all).last.position.should eql(2)
  end
  
  protected
  
  def create_item(options ={})
    Item.create({:name => "item", :date => Time.now, :project_id => 1, :type => "image"}.merge(options))
  end
end