require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/themes/new.html.erb" do
  include ThemesHelper
  
  before(:each) do
    assigns[:theme] = stub_model(Theme,
      :new_record? => true
    )
  end

  it "should render new form" do
    render "/themes/new.html.erb"
    
    response.should have_tag("form[action=?][method=post]", themes_path) do
    end
  end
end


