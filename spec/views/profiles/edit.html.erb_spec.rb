require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/profiles/edit.html.erb" do
  include ProfilesHelper
  
  before(:each) do
    assigns[:profile] = @profile = stub_model(Profile,
      :new_record? => false
    )
  end

  it "should render edit form" do
    render "/profiles/edit.html.erb"
    
    response.should have_tag("form[action=#{profile_path(@profile)}][method=post]") do
    end
  end
end


