require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Font do
  before(:each) do
    @valid_attributes = {
      :name => 'Helmet',
      :font_file_name => 'helmet.swf',
      :font_content_type => 'application/x-shockwave-flash',
      :font_file_size => 2.megabytes
    }
    @font = Font.new
  end

  it "should create a new instance given valid attributes" do
    Font.create!(@valid_attributes)
  end
  
  it "should be invalid without a name" do
    @font.attributes = @valid_attributes.except(:name)
    @font.should_not be_valid
  end
  
  it "should be invalid without an attatched file" do
    @font.attributes = @valid_attributes.except(:font_file_name, :font_content_type, :font_file_size)
    @font.should_not be_valid
  end
  
  it "should be invalid in a format of anything other than flash" do
    @font.attributes = @valid_attributes.except(:font_content_type)
    ['unsupported', 'video/quicktime', 'text/html', 'audio/x-mpeg2', 'application/pdf', 'application/msword'].each do |unsupported_content_type|
      @font.font_content_type = unsupported_content_type
      @font.should_not be_valid
    end
  end
  
  it "should have many styles" do
    association = Font.reflect_on_association(:styles)
    association.should_not be_nil
    association.macro.should eql(:has_many)
  end
end
