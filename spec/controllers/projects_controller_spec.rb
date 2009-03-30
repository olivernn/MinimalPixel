require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ProjectsController do
  
  before(:each) do
    # using 'test' as this is what the subdomain is when running the tests
    User.stub!(:find_by_subdomain).with("test").and_return(mock_user)
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
      mock_user.projects.should_receive(:active).with(no_args).and_return([mock_project])
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
    it "should expose all projects as @projects" do
      mock_user.projects.should_receive(:active).with(no_args).and_return([mock_project])
      get :index
      assigns[:projects].should == [mock_project]
    end

    describe "with mime type of xml" do
      it "should render all projects as xml" do
        request.env["HTTP_ACCEPT"] = "application/xml"
        mock_user.projects.should_receive(:active).with(no_args).and_return(projects = mock("Array of Projects"))
        projects  .should_receive(:to_xml).and_return("generated XML")
        get :index
        response.body.should == "generated XML"
      end
    end
  end

  describe "responding to GET show" do
    it "should expose the requested projects as @projects" do
      mock_user.projects.should_receive(:find).with("37").and_return(mock_project)
      get :show, :id => "37"
      assigns[:project].should equal(mock_project)
    end
    
    describe "with mime type of xml" do
      it "should render the requested projects as xml" do
        request.env["HTTP_ACCEPT"] = "application/xml"
        mock_user.projects.should_receive(:find).with("37").and_return(mock_project)
        mock_project.should_receive(:to_xml).and_return("generated XML")
        get :show, :id => "37"
        response.body.should == "generated XML"
      end
    end
  end
  
  # The new action is not required as new projects are only ever created as draft projects
  #
  # describe "responding to GET new" do
  #   it "should expose a new projects as @projects" do
  #     Project.should_receive(:new).and_return(mock_project)
  #     get :new
  #     assigns[:project].should equal(mock_project)
  #   end
  # end

  describe "responding to GET edit" do
    it "should expose the requested projects as @projects" do
      mock_user.projects.should_receive(:find).with("37").and_return(mock_project)
      get :edit, :id => "37"
      assigns[:project].should equal(mock_project)
    end
  end
  
  # create action is not required because projects are published not created!
  #
  # describe "responding to POST create" do
  #   describe "with valid params" do
  #     it "should expose a newly published project as @project" do
  #       Project.should_receive(:new).with({'these' => 'params'}).and_return(mock_project(:save => true))
  #       post :create, :project => {:these => 'params'}
  #       assigns(:project).should equal(mock_project)
  #     end
  # 
  #     it "should redirect to the created projects" do
  #       Project.stub!(:new).and_return(mock_project(:save => true))
  #       post :create, :project => {}
  #       response.should redirect_to(project_url(mock_project))
  #     end
  #   end
  #   
  #   describe "with invalid params" do
  #     it "should expose a newly created but unsaved projects as @projects" do
  #       Project.stub!(:new).with({'these' => 'params'}).and_return(mock_project(:save => false))
  #       post :create, :project => {:these => 'params'}
  #       assigns(:project).should equal(mock_project)
  #     end
  # 
  #     it "should re-render the 'new' template" do
  #       Project.stub!(:new).and_return(mock_project(:save => false))
  #       post :create, :project => {}
  #       response.should render_template('new')
  #     end   
  #   end
  # end

  describe "responding to PUT udpate" do

    describe "with valid params" do
      it "should update the requested projects" do
        mock_user.projects.should_receive(:find).with("37").and_return(mock_project)
        mock_project.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :project => {:these => 'params'}
      end

      it "should expose the requested projects as @projects" do
        mock_user.projects.stub!(:find).and_return(mock_project(:update_attributes => true))
        mock_user.should_receive(:subdomain).and_return('user_subdomain')
        put :update, :id => "1"
        assigns(:project).should equal(mock_project)
      end

      it "should redirect to the projects" do
        mock_user.projects.stub!(:find).and_return(mock_project(:update_attributes => true))
        mock_user.should_receive(:subdomain).and_return('user_subdomain')
        put :update, :id => "1"
        response.should redirect_to(project_path(mock_project, :subdomain => 'user_subdomain')) 
      end
    end
    
    describe "with invalid params" do
      it "should update the requested projects" do
        mock_user.projects.should_receive(:find).with("37").and_return(mock_project)
        mock_project.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :project => {:these => 'params'}
      end

      it "should expose the projects as @projects" do
        mock_user.projects.stub!(:find).and_return(mock_project(:update_attributes => false))
        put :update, :id => "1"
        assigns(:project).should equal(mock_project)
      end

      it "should re-render the 'edit' template" do
        mock_user.projects.stub!(:find).and_return(mock_project(:update_attributes => false))
        put :update, :id => "1"
        response.should render_template('edit')
      end
    end
  end

  describe "responding to DELETE destroy" do
    it "should destroy the requested projects" do
      mock_user.projects.should_receive(:find).with("37").and_return(mock_project)
      mock_user.should_receive(:subdomain).and_return('mock_user_subdomain')
      mock_project.should_receive(:destroy)
      delete :destroy, :id => "37"
    end
  
    it "should redirect to the projects list" do
      mock_user.projects.stub!(:find).and_return(mock_project(:destroy => true))
      mock_user.should_receive(:subdomain).and_return('mock_user_subdomain')
      delete :destroy, :id => "1"
      response.should redirect_to(project_url(:subdomain => 'mock_user_subdomain'))
    end
  end
end
