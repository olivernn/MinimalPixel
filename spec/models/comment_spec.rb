require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Comment do
  before(:each) do
    @valid_attributes = {
      :article_id => 1,
      :name => 'bob',
      :content => 'this is a comment',
      :created_at => Time.now,
      :updated_at => Time.now
    }
    @comment = Comment.new
  end
  
  it "should create a new instance given valid attributes" do
    Comment.create!(@valid_attributes)
  end
  
  it "should be default name to Annonymous if not set" do
    @comment.attributes = @valid_attributes.except(:name)
    @comment.should be_valid
    @comment.name.should == "Annonymous"
  end
  
  it "should be invalid without any content" do
    @comment.attributes = @valid_attributes.except(:content)
    @comment.should_not be_valid
  end
  
  it "should belong to an article" do
    association = Comment.reflect_on_association(:article)
    association.should_not be_nil
    association.macro.should eql(:belongs_to)
  end
end
