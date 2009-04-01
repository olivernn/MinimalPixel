require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/fonts/new.html.erb" do
  include FontsHelper
  
  before(:each) do
    assigns[:font] = stub_model(Font,
      :new_record? => true
    )
  end

  it "renders new font form" do
    render
    
    response.should have_tag("form[action=?][method=post]", fonts_path) do
    end
  end
end


