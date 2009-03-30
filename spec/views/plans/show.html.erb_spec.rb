require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/plans/show.html.erb" do
  include PlansHelper
  before(:each) do
    assigns[:plan] = @plan = stub_model(Plan)
  end

  it "should render attributes in <p>" do
    render "/plans/show.html.erb"
  end
end

