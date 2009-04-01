require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/fonts/edit.html.erb" do
  include FontsHelper
  
  before(:each) do
    assigns[:font] = @font = stub_model(Font,
      :new_record? => false
    )
  end

  it "renders the edit font form" do
    render
    
    response.should have_tag("form[action=#{font_path(@font)}][method=post]") do
    end
  end
end


