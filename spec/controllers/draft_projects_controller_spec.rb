require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe DraftProjectsController do
  
  before(:each) do
    # using 'test' as this is what the subdomain is when running the tests
    User.stub!(:find_by_subdomain).with("test").and_return(mock_user)
    controller.stub!(:login_required).and_return(true)
  end
  
  def mock_project(stubs={})
    @mock_project ||= mock_model(Project, stubs)
  end
  
  def mock_user(stubs={})
    @mock_user ||= mock_model(User, stubs.reverse_merge(:projects => mock('Array of Items')))
  end
  
  describe "scoping the actions to a user" do
    it "should expose the user as @user" do
      User.should_receive(:find_by_subdomain).with("test").and_return(mock_user)
      mock_user.projects.should_receive(:drafts).with(no_args).and_return([mock_project])
      get :index
      assigns[:user].should == mock_user
    end
  end
  
  describe "handling an unrecognized subdomain" do
    it "should redirect to the root url" do
      User.stub!(:find_by_subdomain).with("test").and_return(false)
      get :index
      response.should redirect_to(root_url)
    end
  end
  
  describe "responding to GET index" do
    it "should expose all draft projects as @projects" do
      mock_user.projects.should_receive(:drafts).and_return([mock_project])
      get :index
      assigns[:projects].should == [mock_project]
    end

    describe "with mime type of xml" do
      it "should render all projects as xml" do
        request.env["HTTP_ACCEPT"] = "application/xml"
        mock_user.projects.should_receive(:drafts).and_return(projects = mock("Array of Projects"))
        projects.should_receive(:to_xml).and_return("generated XML")
        get :index
        response.body.should == "generated XML"
      end
    end
  end
  
  describe "responding to GET new" do
    describe "with project limit not exceeded" do
      it "should expose a new project as @project" do
        mock_user.should_receive(:can_create_projects?).and_return(true)
        mock_user.projects.should_receive(:build).and_return(mock_project)
        get :new
        assigns[:project].should equal(mock_project)
      end
    end
    
    describe "with project limit exceeded" do
      it "should redirect to the projects_index" do
        mock_user.should_receive(:can_create_projects?).and_return(false)
        mock_user.projects.should_receive(:build).and_return(mock_project)
        mock_user.should_receive(:subdomain).and_return('mock_user_subdomain')
        get :new
        response.should redirect_to(draft_projects_url(:subdomain => 'mock_user_subdomain'))
      end
    end
  end
  
  describe "responding to POST create" do
    describe "with valid params" do
      it "should expose a newly created project as @project" do
        mock_user.projects.should_receive(:build).with({'these' => 'params'}).and_return(mock_project(:save => true))
        mock_user.should_receive(:subdomain).and_return('mock_user_subdomain')
        post :create, :project => {:these => 'params'}
        assigns(:project).should equal(mock_project)
      end
      
      it "should redirect to the created project" do
        mock_user.projects.stub!(:build).and_return(mock_project(:save => true))
        mock_user.should_receive(:subdomain).and_return('mock_user_subdomain')
        post :create, :project => {}
        response.should redirect_to(project_path(mock_project, :subdomain => 'mock_user_subdomain'))
      end
    end
    
    describe "with invalid parameters" do  
      it "should expose a newly created but unsaved project as @project" do
        mock_user.projects.stub!(:build).with({'these' => 'params'}).and_return(mock_project(:save => false))
        post :create, :project => {:these => 'params'}
        assigns(:project).should equal(mock_project)
      end

      it "should re-render the 'new' template" do
        mock_user.projects.stub!(:build).and_return(mock_project(:save => false))
        post :create, :project => {}
        response.should render_template('new')
      end    
    end
  end
  
  describe "responding to PUT publish" do
    describe "with valid params" do    
      it "should find and publish a project with the given id" do
        mock_user.projects.should_receive(:find).with("37").and_return(mock_project)
        mock_project.should_receive(:publish!)
        mock_user.should_receive(:subdomain).and_return('mock_user_subdomain')
        put :publish, :id => "37"
        assigns[:project].should equal(mock_project)
      end
      
      it "should redirect to the created project" do
        mock_user.projects.stub!(:find).and_return(mock_project(:publish! => true))
        mock_user.should_receive(:subdomain).and_return('mock_user_subdomain')
        put :publish, :id => "37"
        response.should redirect_to(project_url(mock_project, :subdomain => 'mock_user_subdomain'))
      end
        
    end
    
    describe "with an id of a project that is already active" do
      it "should redirect to the found project" do
        mock_user.projects.stub!(:find).and_return(mock_project(:publish! => false))
        mock_user.should_receive(:subdomain).and_return('mock_user_subdomain')
        put :publish, :id => "37"
        response.should redirect_to(project_url(mock_project, :subdomain => 'mock_user_subdomain'))
      end
    end
  end
end
