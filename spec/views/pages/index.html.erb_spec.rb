require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/pages/index.html.erb" do
  include PagesHelper
  
  before(:each) do
    assigns[:pages] = [
      stub_model(Page),
      stub_model(Page)
    ]
  end

  it "renders a list of pages" do
    render
  end
end

