require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Question do
  before(:each) do
    @valid_attributes = {
      :question => 'Why did the chicken cross the road?',
      :answer => 'To get to the other side',
      :created_at => Time.now,
      :updated_at => Time.now
    }
    @question = Question.new
  end

  it "should create a new instance given valid attributes" do
    Question.create!(@valid_attributes)
  end
  
  it "should be invalid without a question" do
    @question.attributes = @valid_attributes.except(:question)
    @question.should_not be_valid
  end
  
  it "should be invalid without an answer" do
    @question.attributes = @valid_attributes.except(:answer)
    @question.should_not be_valid
  end
  
  it "should always have a question attribute ending with a ?" do
    @question.attributes = @valid_attributes.except(:question)
    @question.question = "no question mark"
    @question.save
    @question.question.include?('?').should == true
  end
end
