require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ImagesController do

  def mock_image(stubs={})
    @mock_image ||= mock_model(Image, stubs)
  end
  
  def mock_project(stubs={})
    @mock_project ||= mock_model(Project, stubs.reverse_merge(:images => mock('Array of Images')))
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

  describe "responding to GET new" do
    it "should expose a new image as @image" do
      mock_project.images.should_receive(:build).and_return(mock_image)
      get :new, :project_id => "1"
      assigns[:image].should equal(mock_image)
    end

  end

  describe "responding to GET edit" do
    it "should expose the requested image as @image" do
      mock_project.images.should_receive(:find).with("37").and_return(mock_image)
      get :edit, :id => "37", :project_id => "1"
      assigns[:image].should equal(mock_image)
    end
  end

  describe "responding to POST create" do
    describe "with valid params" do
      it "should expose a newly created image as @image" do
        mock_project.images.should_receive(:build).with({'these' => 'params'}).and_return(mock_image(:save => true))
        mock_user.should_receive(:subdomain).and_return('test_subdomain')
        post :create, :image => {:these => 'params'}, :project_id => "1"
        assigns(:image).should equal(mock_image)
      end

      it "should redirect to the created image" do
        mock_project.images.stub!(:build).and_return(mock_image(:save => true))
        mock_user.should_receive(:subdomain).and_return('test_subdomain')
        post :create, :image => {}, :project_id => "1"
        response.should redirect_to(project_image_url(mock_project, mock_image, :subdomain => 'test_subdomain'))
      end  
    end
    
    describe "with invalid params" do
      it "should expose a newly created but unsaved image as @image" do
        mock_project.images.stub!(:build).with({'these' => 'params'}).and_return(mock_image(:save => false))
        post :create, :image => {:these => 'params'}, :project_id => "1"
        assigns(:image).should equal(mock_image)
      end

      it "should re-render the 'new' template" do
        mock_project.images.stub!(:build).and_return(mock_image(:save => false))
        post :create, :image => {}, :project_id => "1"
        response.should render_template('new')
      end   
    end 
  end

  describe "responding to PUT udpate" do
    describe "with valid params" do
      it "should update the requested image" do
        mock_project.images.should_receive(:find).with("37").and_return(mock_image)
        mock_image.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :image => {:these => 'params'}, :project_id => "1"
      end

      it "should expose the requested image as @image" do
        mock_project.images.stub!(:find).and_return(mock_image(:update_attributes => true))
        mock_user.should_receive(:subdomain).and_return('test_subdomain')
        put :update, :id => "1", :project_id => "1"
        assigns(:image).should equal(mock_image)
      end

      it "should redirect to the image" do
        mock_project.images.stub!(:find).and_return(mock_image(:update_attributes => true))
        mock_user.should_receive(:subdomain).and_return('test_subdomain')
        put :update, :id => "1", :project_id => "1"
        response.should redirect_to(project_image_url(mock_project, mock_image, :subdomain => 'test_subdomain'))
      end
    end
    
    describe "with invalid params" do
      it "should update the requested image" do
        mock_project.images.should_receive(:find).with("37").and_return(mock_image)
        mock_image.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :image => {:these => 'params'}, :project_id => "1"
      end

      it "should expose the image as @image" do
        mock_project.images.stub!(:find).and_return(mock_image(:update_attributes => false))
        put :update, :id => "1", :project_id => "1"
        assigns(:image).should equal(mock_image)
      end

      it "should re-render the 'edit' template" do
        mock_project.images.stub!(:find).and_return(mock_image(:update_attributes => false))
        put :update, :id => "1", :project_id => "1"
        response.should render_template('edit')
      end
    end
  end
end
