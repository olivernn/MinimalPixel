require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/images/edit.html.erb" do
  include ImagesHelper
  
  before(:each) do
    assigns[:project] = @project = stub_model(Project)
    assigns[:image] = @image = stub_model(Image,
      :new_record? => false
    )
  end

  it "should render edit form" do
    render "/images/edit.html.erb"
    
    response.should have_tag("form[action=#{project_image_path(@project, @image)}][method=post]") do
    end
  end
end


