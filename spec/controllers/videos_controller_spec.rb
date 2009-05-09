require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe VideosController do

  def mock_video(stubs={})
    @mock_video ||= mock_model(Video, stubs)
  end
  
  def mock_project(stubs={})
    @mock_project ||= mock_model(Project, stubs.reverse_merge(:videos => mock('Array of Videos')))
  end
  
  before(:each) do
    Project.stub!(:find).with("1").and_return(mock_project)
  end
    
  describe "responding to GET index" do

    it "should expose all videos as @videos" do
      mock_project.should_receive(:videos).with(no_args).and_return([mock_video])
      get :index, :project_id => "1"
      assigns[:videos].should == [mock_video]
    end

    describe "with mime type of xml" do
  
      it "should render all videos as xml" do
        request.env["HTTP_ACCEPT"] = "application/xml"
        mock_project.should_receive(:videos).with(no_args).and_return(videos = mock("Array of Videos"))
        videos.should_receive(:to_xml).and_return("generated XML")
        get :index, :project_id => "1"
        response.body.should == "generated XML"
      end
    
    end

  end

  describe "responding to GET show" do

    it "should expose the requested video as @video" do
      mock_project.videos.should_receive(:find).with("37").and_return(mock_video)
      get :show, :id => "37", :project_id => "1"
      assigns[:video].should equal(mock_video)
    end
    
    describe "with mime type of xml" do

      it "should render the requested video as xml" do
        request.env["HTTP_ACCEPT"] = "application/xml"
        mock_project.videos.should_receive(:find).with("37").and_return(mock_video)
        mock_video.should_receive(:to_xml).and_return("generated XML")
        get :show, :id => "37", :project_id => "1"
        response.body.should == "generated XML"
      end

    end
    
  end

  describe "responding to GET new" do
  
    it "should expose a new video as @video" do
      mock_project.videos.should_receive(:build).and_return(mock_video)
      get :new, :project_id => "1"
      assigns[:video].should equal(mock_video)
    end

  end

  describe "responding to GET edit" do
  
    it "should expose the requested video as @video" do
      mock_project.videos.should_receive(:find).with("37").and_return(mock_video)
      get :edit, :id => "37", :project_id => "1"
      assigns[:video].should equal(mock_video)
    end

  end

  describe "responding to POST create" do

    describe "with valid params" do
      
      it "should expose a newly created video as @video" do
        mock_project.videos.should_receive(:build).with({'these' => 'params'}).and_return(mock_video(:save => true))
        post :create, :video => {:these => 'params'}, :project_id => "1"
        assigns(:video).should equal(mock_video)
      end

      it "should redirect to the created video" do
        mock_project.videos.stub!(:build).and_return(mock_video(:save => true))
        post :create, :video => {}, :project_id => "1"
        response.should redirect_to(project_video_url(mock_project, mock_video))
      end
      
    end
    
    describe "with invalid params" do

      it "should expose a newly created but unsaved video as @video" do
        mock_project.videos.stub!(:build).with({'these' => 'params'}).and_return(mock_video(:save => false))
        post :create, :video => {:these => 'params'}, :project_id => "1"
        assigns(:video).should equal(mock_video)
      end

      it "should re-render the 'new' template" do
        mock_project.videos.stub!(:build).and_return(mock_video(:save => false))
        post :create, :video => {}, :project_id => "1"
        response.should render_template('new')
      end
      
    end
    
  end

  describe "responding to PUT udpate" do

    describe "with valid params" do

      it "should update the requested video" do
        mock_project.videos.should_receive(:find).with("37").and_return(mock_video)
        mock_video.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :video => {:these => 'params'}, :project_id => "1"
      end

      it "should expose the requested video as @video" do
        mock_project.videos.stub!(:find).and_return(mock_video(:update_attributes => true))
        put :update, :id => "1", :project_id => "1"
        assigns(:video).should equal(mock_video)
      end

      it "should redirect to the video" do
        mock_project.videos.stub!(:find).and_return(mock_video(:update_attributes => true))
        put :update, :id => "1", :project_id => "1"
        response.should redirect_to(project_video_url(mock_project, mock_video))
      end

    end
    
    describe "with invalid params" do

      it "should update the requested video" do
        mock_project.videos.should_receive(:find).with("37").and_return(mock_video)
        mock_video.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :video => {:these => 'params'}, :project_id => "1"
      end

      it "should expose the video as @video" do
        mock_project.videos.stub!(:find).and_return(mock_video(:update_attributes => false))
        put :update, :id => "1", :project_id => "1"
        assigns(:video).should equal(mock_video)
      end

      it "should re-render the 'edit' template" do
        mock_project.videos.stub!(:find).and_return(mock_video(:update_attributes => false))
        put :update, :id => "1", :project_id => "1"
        response.should render_template('edit')
      end

    end

  end

  describe "responding to DELETE destroy" do

    it "should destroy the requested video" do
      mock_project.videos.should_receive(:find).with("37").and_return(mock_video)
      mock_video.should_receive(:destroy)
      delete :destroy, :id => "37", :project_id => "1"
    end
  
    it "should redirect to the videos list" do
      mock_project.videos.stub!(:find).and_return(mock_video(:destroy => true))
      delete :destroy, :id => "1", :project_id => "1"
      response.should redirect_to(project_videos_url(mock_project))
    end

  end

end
