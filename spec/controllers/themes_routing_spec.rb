require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ThemesController do
  describe "route generation" do
    it "should map #index" do
      route_for(:controller => "themes", :action => "index").should == "/themes"
    end
  
    it "should map #new" do
      route_for(:controller => "themes", :action => "new").should == "/themes/new"
    end
  
    it "should map #show" do
      route_for(:controller => "themes", :action => "show", :id => 1).should == "/themes/1"
    end
  
    it "should map #edit" do
      route_for(:controller => "themes", :action => "edit", :id => 1).should == "/themes/1/edit"
    end
  
    it "should map #update" do
      route_for(:controller => "themes", :action => "update", :id => 1).should == "/themes/1"
    end
  
    it "should map #destroy" do
      route_for(:controller => "themes", :action => "destroy", :id => 1).should == "/themes/1"
    end
  end

  describe "route recognition" do
    it "should generate params for #index" do
      params_from(:get, "/themes").should == {:controller => "themes", :action => "index"}
    end
  
    it "should generate params for #new" do
      params_from(:get, "/themes/new").should == {:controller => "themes", :action => "new"}
    end
  
    it "should generate params for #create" do
      params_from(:post, "/themes").should == {:controller => "themes", :action => "create"}
    end
  
    it "should generate params for #show" do
      params_from(:get, "/themes/1").should == {:controller => "themes", :action => "show", :id => "1"}
    end
  
    it "should generate params for #edit" do
      params_from(:get, "/themes/1/edit").should == {:controller => "themes", :action => "edit", :id => "1"}
    end
  
    it "should generate params for #update" do
      params_from(:put, "/themes/1").should == {:controller => "themes", :action => "update", :id => "1"}
    end
  
    it "should generate params for #destroy" do
      params_from(:delete, "/themes/1").should == {:controller => "themes", :action => "destroy", :id => "1"}
    end
  end
end
