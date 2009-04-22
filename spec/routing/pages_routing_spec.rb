require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe PagesController do
  describe "route generation" do
    it "maps #index" do
      route_for(:controller => "pages", :action => "index").should == "/pages"
    end
  
    it "maps #new" do
      route_for(:controller => "pages", :action => "new").should == "/pages/new"
    end
  
    it "maps #show" do
      route_for(:controller => "pages", :action => "show", :id => "1").should == "/pages/1"
    end
  
    it "maps #edit" do
      route_for(:controller => "pages", :action => "edit", :id => "1").should == "/pages/1/edit"
    end

  it "maps #create" do
    route_for(:controller => "pages", :action => "create").should == {:path => "/pages", :method => :post}
  end

  it "maps #update" do
    route_for(:controller => "pages", :action => "update", :id => "1").should == {:path =>"/pages/1", :method => :put}
  end
  
    it "maps #destroy" do
      route_for(:controller => "pages", :action => "destroy", :id => "1").should == {:path =>"/pages/1", :method => :delete}
    end
  end

  describe "route recognition" do
    it "generates params for #index" do
      params_from(:get, "/pages").should == {:controller => "pages", :action => "index"}
    end
  
    it "generates params for #new" do
      params_from(:get, "/pages/new").should == {:controller => "pages", :action => "new"}
    end
  
    it "generates params for #create" do
      params_from(:post, "/pages").should == {:controller => "pages", :action => "create"}
    end
  
    it "generates params for #show" do
      params_from(:get, "/pages/1").should == {:controller => "pages", :action => "show", :id => "1"}
    end
  
    it "generates params for #edit" do
      params_from(:get, "/pages/1/edit").should == {:controller => "pages", :action => "edit", :id => "1"}
    end
  
    it "generates params for #update" do
      params_from(:put, "/pages/1").should == {:controller => "pages", :action => "update", :id => "1"}
    end
  
    it "generates params for #destroy" do
      params_from(:delete, "/pages/1").should == {:controller => "pages", :action => "destroy", :id => "1"}
    end
  end
end
