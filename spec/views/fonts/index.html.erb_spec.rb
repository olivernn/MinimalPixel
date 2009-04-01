require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/fonts/index.html.erb" do
  include FontsHelper
  
  before(:each) do
    assigns[:fonts] = [
      stub_model(Font),
      stub_model(Font)
    ]
  end

  it "renders a list of fonts" do
    render
  end
end

