require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe PlansController do
  describe "route generation" do
    it "should map #index" do
      route_for(:controller => "plans", :action => "index").should == "/plans"
    end
  
    it "should map #new" do
      route_for(:controller => "plans", :action => "new").should == "/plans/new"
    end
  
    it "should map #show" do
      route_for(:controller => "plans", :action => "show", :id => 1).should == "/plans/1"
    end
  
    it "should map #edit" do
      route_for(:controller => "plans", :action => "edit", :id => 1).should == "/plans/1/edit"
    end
  
    it "should map #update" do
      route_for(:controller => "plans", :action => "update", :id => 1).should == "/plans/1"
    end
  
    it "should map #destroy" do
      route_for(:controller => "plans", :action => "destroy", :id => 1).should == "/plans/1"
    end
  end

  describe "route recognition" do
    it "should generate params for #index" do
      params_from(:get, "/plans").should == {:controller => "plans", :action => "index"}
    end
  
    it "should generate params for #new" do
      params_from(:get, "/plans/new").should == {:controller => "plans", :action => "new"}
    end
  
    it "should generate params for #create" do
      params_from(:post, "/plans").should == {:controller => "plans", :action => "create"}
    end
  
    it "should generate params for #show" do
      params_from(:get, "/plans/1").should == {:controller => "plans", :action => "show", :id => "1"}
    end
  
    it "should generate params for #edit" do
      params_from(:get, "/plans/1/edit").should == {:controller => "plans", :action => "edit", :id => "1"}
    end
  
    it "should generate params for #update" do
      params_from(:put, "/plans/1").should == {:controller => "plans", :action => "update", :id => "1"}
    end
  
    it "should generate params for #destroy" do
      params_from(:delete, "/plans/1").should == {:controller => "plans", :action => "destroy", :id => "1"}
    end
  end
end
