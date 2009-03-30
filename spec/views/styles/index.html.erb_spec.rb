require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/styles/index.html.erb" do
  include StylesHelper
  
  before(:each) do
    assigns[:styles] = [
      stub_model(Style),
      stub_model(Style)
    ]
  end

  it "should render list of styles" do
    render "/styles/index.html.erb"
  end
end

