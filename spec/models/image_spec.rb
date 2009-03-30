require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Image do
  before(:each) do
    @valid_attributes = {
      :id => 1,
      :project_id => 1,
      :position => 1,
      :name => 'my amazing piece of art',
      :description => 'my very painting',
      :date => Date.today.to_s,
      :type => "image",
      :source_file_name => "test_file_name",
      :source_content_type => "image/jpeg",
      :source_file_size => 2.megabytes,
      :created_at => Time.now,
      :updated_at => Time.now
    }
    @image = Image.new
  end

  it "should create a new instance given valid attributes" do
    Image.create!(@valid_attributes)
  end
  
  it "should belong to a project" do
    association = Image.reflect_on_association(:project)
    association.should_not be_nil
    association.macro.should == :belongs_to
  end
  
  it "should be invalid without an attatched file" do
    @image.attributes = @valid_attributes.except(:source_file_name, :source_content_type, :source_file_size)
    @image.should_not be_valid
  end
  
  it "should be invalid with a massive(bigger than 5MB) attatched file" do
    @image.attributes = @valid_attributes.except(:source_file_size)
    @image.source_file_size = 50.megabytes
    @image.should_not be_valid
  end
  
  it "should be invalid without a supported image format" do
    @image.attributes = @valid_attributes.except(:source_content_type)
    ['unsupported', 'video/quicktime', 'text/html', 'audio/x-mpeg2', 'application/pdf', 'application/msword'].each do |unsupported_content_type|
      @image.source_content_type = unsupported_content_type
      @image.should_not be_valid
    end
  end
  
  it "should be valid with a supported image format" do
    @image.attributes = @valid_attributes.except(:source_content_type)
    ['image/gif', 'image/x-png', 'image/jpeg', 'image/tiff', 'image/x-pict'].each do |supported_content_type|
      @image.source_content_type = supported_content_type
      @image.should be_valid
    end
  end
end
