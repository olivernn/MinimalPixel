require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/projects/index.html.erb" do
  include ProjectsHelper
  
  before(:each) do
    assigns[:projects] = [
      stub_model(Projects),
      stub_model(Projects)
    ]
  end

  it "should render list of projects" do
    render "/projects/index.html.erb"
  end
end

