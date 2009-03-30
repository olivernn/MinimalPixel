require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/projects/edit.html.erb" do
  include ProjectsHelper
  
  before(:each) do
    assigns[:projects] = @projects = stub_model(Projects,
      :new_record? => false
    )
  end

  it "should render edit form" do
    render "/projects/edit.html.erb"
    
    response.should have_tag("form[action=#{projects_path(@projects)}][method=post]") do
    end
  end
end


