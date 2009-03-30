require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/plans/new.html.erb" do
  include PlansHelper
  
  before(:each) do
    assigns[:plan] = stub_model(Plan,
      :new_record? => true
    )
  end

  it "should render new form" do
    render "/plans/new.html.erb"
    
    response.should have_tag("form[action=?][method=post]", plans_path) do
    end
  end
end


