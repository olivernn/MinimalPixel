require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/themes/edit.html.erb" do
  include ThemesHelper
  
  before(:each) do
    assigns[:theme] = @theme = stub_model(Theme,
      :new_record? => false
    )
  end

  it "should render edit form" do
    render "/themes/edit.html.erb"
    
    response.should have_tag("form[action=#{theme_path(@theme)}][method=post]") do
    end
  end
end


