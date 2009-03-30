require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/images/new.html.erb" do
  include ImagesHelper
  
  before(:each) do
    assigns[:project] = @project = stub_model(Project)
    assigns[:image] = stub_model(Image,
      :new_record? => true
    )
  end

  it "should render new form" do
    render "/images/new.html.erb"
    
    response.should have_tag("form[action=?][method=post]", project_images_path(@project)) do
    end
  end
end


