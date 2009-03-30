require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ItemsController do

  def mock_item(stubs={})
    @mock_item ||= mock_model(Item, stubs)
  end
  
  def mock_project(stubs={})
    @mock_project ||= mock_model(Project, stubs.reverse_merge(:items => mock('Array of Items')))
  end
  
  def mock_user(stubs={})
    @mock_user ||= mock_model(User, stubs.reverse_merge(:projects => mock('Array of Projects')))
  end
  
  before(:each) do
    # using 'test' as this is what the subdomain is when running the tests
    User.stub!(:find_by_subdomain).with("test").and_return(mock_user)
  end
  
  before(:each) do
    mock_user.projects.stub!(:find).with("1").and_return(mock_project)
  end
  
  describe "scoping the actions to a user" do
    it "should expose the user as @user" do
      User.should_receive(:find_by_subdomain).with("test").and_return(mock_user)
      get :index, :project_id => "1"
      assigns[:user].should == mock_user
    end
  end
  
  describe "handling an unrecognized subdomain" do
    it "should redirect to the root url" do
      User.stub!(:find_by_subdomain).with("test").and_return(false)
      get :index, :project_id => "1"
      response.should redirect_to(root_url)
    end
  end
  
  describe "scoping the actions to a project" do
    it "should expose the project as @project" do
      mock_user.projects.should_receive(:find).with("37").and_return(mock_project)
      get :index, :project_id => "37"
      assigns[:project].should == mock_project
    end
    
    describe "handling a un-recognized project id" do
      it "should issue a warning and redirect to projects index" do
        mock_user.projects.should_receive(:find).with("99").and_raise(ActiveRecord::RecordNotFound)
        get :index, :project_id => "99"
        response.should redirect_to(projects_url)
      end
    end
  end
    
  describe "responding to GET index" do
    it "should expose all items as @items" do
      mock_project.should_receive(:items).with(no_args).and_return([mock_item])
      get :index, :project_id => "1"
      assigns[:items].should == [mock_item]
    end

    describe "with mime type of xml" do
      it "should render all items as xml" do
        request.env["HTTP_ACCEPT"] = "application/xml"
        mock_project.should_receive(:items).with(no_args).and_return(items = mock("Array of Items"))
        items.should_receive(:to_xml).and_return("generated XML")
        get :index, :project_id => "1"
        response.body.should == "generated XML"
      end
    end
  end

  describe "responding to GET show" do
    it "should expose the requested item as @item" do
      mock_project.items.should_receive(:find).with("37").and_return(mock_item)
      get :show, :id => "37", :project_id => "1"
      assigns[:item].should equal(mock_item)
    end
    
    describe "with mime type of xml" do
      it "should render the requested item as xml" do
        request.env["HTTP_ACCEPT"] = "application/xml"
        mock_project.items.should_receive(:find).with("37").and_return(mock_item)
        mock_item.should_receive(:to_xml).and_return("generated XML")
        get :show, :id => "37", :project_id => "1"
        response.body.should == "generated XML"
      end
    end
  end

  describe "responding to DELETE destroy" do
    it "should destroy the requested item" do
      mock_project.items.should_receive(:find).with("37").and_return(mock_item)
      mock_user.should_receive(:subdomain).and_return('mock_user_subdomain')
      mock_item.should_receive(:destroy)
      delete :destroy, :id => "37", :project_id => "1"
    end

    it "should redirect to the items list" do
      mock_project.items.stub!(:find).and_return(mock_item(:destroy => true))
      mock_user.should_receive(:subdomain).and_return('mock_user_subdomain')
      delete :destroy, :id => "1", :project_id => "1"
      response.should redirect_to(project_items_url(mock_project, :subdomain => 'mock_user_subdomain'))
    end
  end
end
