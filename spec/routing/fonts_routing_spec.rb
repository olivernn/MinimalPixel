require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe FontsController do
  describe "route generation" do
    it "maps #index" do
      route_for(:controller => "fonts", :action => "index").should == "/fonts"
    end
  
    it "maps #new" do
      route_for(:controller => "fonts", :action => "new").should == "/fonts/new"
    end
  
    it "maps #show" do
      route_for(:controller => "fonts", :action => "show", :id => "1").should == "/fonts/1"
    end
  
    it "maps #edit" do
      route_for(:controller => "fonts", :action => "edit", :id => "1").should == "/fonts/1/edit"
    end

  it "maps #create" do
    route_for(:controller => "fonts", :action => "create").should == {:path => "/fonts", :method => :post}
  end

  it "maps #update" do
    route_for(:controller => "fonts", :action => "update", :id => "1").should == {:path =>"/fonts/1", :method => :put}
  end
  
    it "maps #destroy" do
      route_for(:controller => "fonts", :action => "destroy", :id => "1").should == {:path =>"/fonts/1", :method => :delete}
    end
  end

  describe "route recognition" do
    it "generates params for #index" do
      params_from(:get, "/fonts").should == {:controller => "fonts", :action => "index"}
    end
  
    it "generates params for #new" do
      params_from(:get, "/fonts/new").should == {:controller => "fonts", :action => "new"}
    end
  
    it "generates params for #create" do
      params_from(:post, "/fonts").should == {:controller => "fonts", :action => "create"}
    end
  
    it "generates params for #show" do
      params_from(:get, "/fonts/1").should == {:controller => "fonts", :action => "show", :id => "1"}
    end
  
    it "generates params for #edit" do
      params_from(:get, "/fonts/1/edit").should == {:controller => "fonts", :action => "edit", :id => "1"}
    end
  
    it "generates params for #update" do
      params_from(:put, "/fonts/1").should == {:controller => "fonts", :action => "update", :id => "1"}
    end
  
    it "generates params for #destroy" do
      params_from(:delete, "/fonts/1").should == {:controller => "fonts", :action => "destroy", :id => "1"}
    end
  end
end
