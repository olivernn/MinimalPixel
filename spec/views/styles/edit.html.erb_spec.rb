require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/styles/edit.html.erb" do
  include StylesHelper
  
  before(:each) do
    assigns[:style] = @style = stub_model(Style,
      :new_record? => false
    )
  end

  it "should render edit form" do
    render "/styles/edit.html.erb"
    
    response.should have_tag("form[action=#{style_path(@style)}][method=post]") do
    end
  end
end


