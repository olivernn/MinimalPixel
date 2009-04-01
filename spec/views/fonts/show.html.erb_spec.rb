require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/fonts/show.html.erb" do
  include FontsHelper
  before(:each) do
    assigns[:font] = @font = stub_model(Font)
  end

  it "renders attributes in <p>" do
    render
  end
end

