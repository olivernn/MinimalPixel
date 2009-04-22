require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Page do
  before(:each) do
    @valid_attributes = {
      :user_id => 1,
      :title => 'About Me',
      :permalink => 'about_me',
      :content => 'A page all about me!'
    }
    @page = Page.new
  end

  it "should create a new instance given valid attributes" do
    Page.create!(@valid_attributes)
  end
  
  it "should be invalid without a title" do
    @page.attributes = @valid_attributes.except(:title)
    @page.should_not be_valid
  end
  
  it "should be invalid without a permalink" do
    @page.attributes = @valid_attributes.except(:permalink)
    @page.save
    @page.permalink = ""
    @page.should_not be_valid
  end
  
  it "should be invalid with a duplicate permalink" do
    @page.attributes = @valid_attributes
    @page.save
    @another_page = Page.new
    @another_page.attributes = @valid_attributes
    @another_page.should_not be_valid
  end
  
  it "should be invalid without any content" do
    @page.attributes = @valid_attributes.except(:content)
    @page.should_not be_valid
  end
  
  describe "generating the permalink" do
    it "should not contain any spaces" do
      @page.attributes = @valid_attributes.except(:permalink)
      @page.save
      @page.permalink.include?(" ").should_not eql(true)
    end
    
    it "should have been escaped" do
      @page.attributes = @valid_attributes.except(:permalink, :title)
      @page.title = "& This shouldn't be a permalink!"
      @page.save
      @page.permalink.should eql(CGI.escape(@page.title.gsub(' ','_')))
    end
    
    it "should not change once created" do
      @page.attributes = @valid_attributes.except(:permalink)
      @page.save
      @page.update_attribute('title', "not about me")
      @page.permalink.should eql("About_Me")
    end
  end
  
  it "should have expose permalink as its param" do
    @page.attributes = @valid_attributes
    @page.save
    @page.to_param.should_not eql(@page.id)
    @page.to_param.should eql(@page.permalink)
  end
  
  it "should convert the content into html" do
    @page.attributes = @valid_attributes.except(:content)
    @page.content = "*textile markup*"
    @page.save
    @page.content.should eql("<p><strong>textile markup</strong></p>")
  end
  
  it "should belong to a user" do
    association = Page.reflect_on_association(:user)
    association.should_not be_nil
    association.macro.should == :belongs_to
  end
end
