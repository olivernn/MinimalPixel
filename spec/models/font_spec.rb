require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Font do
  before(:each) do
    @valid_attributes = {
      :name => 'Helmet',
      :font_file_name => 'geo_sans_light',
      :font_content_type =>
    }
  end

  it "should create a new instance given valid attributes" do
    Font.create!(@valid_attributes)
  end
end
