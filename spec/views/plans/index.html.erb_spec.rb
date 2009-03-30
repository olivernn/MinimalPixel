require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/plans/index.html.erb" do
  include PlansHelper
  
  before(:each) do
    assigns[:plans] = [
      stub_model(Plan),
      stub_model(Plan)
    ]
  end

  it "should render list of plans" do
    render "/plans/index.html.erb"
  end
end

