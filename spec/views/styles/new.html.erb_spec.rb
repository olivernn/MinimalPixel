require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/styles/new.html.erb" do
  include StylesHelper
  
  before(:each) do
    assigns[:style] = stub_model(Style,
      :new_record? => true
    )
  end

  it "should render new form" do
    render "/styles/new.html.erb"
    
    response.should have_tag("form[action=?][method=post]", styles_path) do
    end
  end
end


