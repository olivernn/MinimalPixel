require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/themes/show.html.erb" do
  include ThemesHelper
  before(:each) do
    assigns[:theme] = @theme = stub_model(Theme)
  end

  it "should render attributes in <p>" do
    render "/themes/show.html.erb"
  end
end

