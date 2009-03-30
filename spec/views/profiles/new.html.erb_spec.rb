require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/profiles/new.html.erb" do
  include ProfilesHelper
  
  before(:each) do
    assigns[:profile] = stub_model(Profile,
      :new_record? => true
    )
  end

  it "should render new form" do
    render "/profiles/new.html.erb"
    
    response.should have_tag("form[action=?][method=post]", profiles_path) do
    end
  end
end


