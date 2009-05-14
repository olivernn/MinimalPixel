require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Article do
  before(:each) do
    @valid_attributes = {
      :title => 'Welcome To Minimal Pixel',
      :content => 'Simply the easiest way to create your own portfolio',
      :permalink => 'welcome-to-minimal-pixel',
      :date => Time.now,
      :status => 'active'
    }
    @article = Article.new
  end

  it "should create a new instance given valid attributes" do
    Article.create!(@valid_attributes)
  end
  
  it "should be invalid without a title" do
    @article.attributes = @valid_attributes.except(:title)
    @article.should_not be_valid
  end
  
  it "should be invalud without some content" do
    @article.attributes = @valid_attributes.except(:content)
    @article.should_not be_valid
  end
  
  it "should be invalid without a permalink" do
    @article.attributes = @valid_attributes.except(:permalink)
    @article.save
    @article.permalink = ""
    @article.should_not be_valid
  end
  
  it "should be invalid with a duplicate permalink" do
    @article.attributes = @valid_attributes
    @article.save
    @another_article = Article.new
    @another_article.attributes = @valid_attributes
    @another_article.should_not be_valid
  end
  
  describe "generating the permalink" do
    it "should not contain any spaces" do
      @article.attributes = @valid_attributes.except(:permalink)
      @article.save
      @article.permalink.include?(" ").should_not eql(true)
    end
    
    it "should have been escaped" do
      @article.attributes = @valid_attributes.except(:permalink, :title)
      @article.title = "& This shouldn't be a permalink!"
      @article.save
      @article.permalink.should eql(@article.title.parameterize.to_s)
    end
    
    it "should not change once created" do
      @article.attributes = @valid_attributes.except(:permalink)
      @article.save
      @article.update_attribute('title', "not about me")
      @article.permalink.should eql("welcome-to-minimal-pixel")
    end
  end
  
  it "should convert the content into html" do
    @article.attributes = @valid_attributes.except(:content)
    @article.content = "*textile markup*"
    @article.save
    @article.content.should eql("<p><strong>textile markup</strong></p>")
  end
  
  it "should have an initial status of 'draft'" do
    @article.attributes = @valid_attributes.except(:status)
    @article.save
    @article.status.should == 'draft'
  end
  
  it "should have a status of 'active' after being published" do
    @article.attributes = @valid_attributes.except(:status)
    @article.save
    @article.publish!
    @article.status.should == 'active'
  end
end
