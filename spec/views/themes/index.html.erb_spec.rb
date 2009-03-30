require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/themes/index.html.erb" do
  include ThemesHelper
  
  before(:each) do
    assigns[:themes] = [
      stub_model(Theme),
      stub_model(Theme)
    ]
  end

  it "should render list of themes" do
    render "/themes/index.html.erb"
  end
end

