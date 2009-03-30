require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/plans/edit.html.erb" do
  include PlansHelper
  
  before(:each) do
    assigns[:plan] = @plan = stub_model(Plan,
      :new_record? => false
    )
  end

  it "should render edit form" do
    render "/plans/edit.html.erb"
    
    response.should have_tag("form[action=#{plan_path(@plan)}][method=post]") do
    end
  end
end


