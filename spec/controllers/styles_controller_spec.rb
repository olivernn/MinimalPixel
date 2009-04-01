require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe StylesController do
  
  before(:each) do
    # using 'test' as this is what the subdomain is when running the tests
    User.stub!(:find_by_subdomain).with("test").and_return(mock_user)
    controller.stub!(:login_required).and_return(true)
  end
  
  def mock_user(stubs={})
    @mock_user ||= mock_model(User, stubs.reverse_merge(:style => mock('Style')))
  end
  
  def mock_style(stubs={})
    @mock_style ||= mock_model(Style, stubs)
  end
  
  describe "scoping the actions to a user" do
    it "should expose the user as @user" do
      User.should_receive(:find_by_subdomain).with("test").and_return(mock_user)
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
    it "should expose the requested style as @style" do
      mock_user.should_receive(:style).with(no_args).and_return(mock_style)
      get :index
      assigns[:style].should equal(mock_style)
    end
    
    describe "with mime type of css" do
      it "should render the requested css stylesheet" do
        request.env["HTTP_ACCEPT"] = "text/css"
        mock_user.should_receive(:style).with(no_args).and_return(mock_style)
        get :index
        response.headers['Content-Type'].should == "text/css"
      end
    end
  end

  describe "responding to GET edit" do 
    it "should expose the requested style as @style" do
      mock_user.should_receive(:style).with(no_args).and_return(mock_style)
      get :edit, :id => "37"
      assigns[:style].should equal(mock_style)
    end
  end

  describe "responding to PUT udpate" do
    describe "with valid params" do
      it "should update the requested style" do
        mock_user.should_receive(:style).with(no_args).and_return(mock_style)
        mock_style.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :style => {:these => 'params'}
      end

      it "should expose the requested style as @style" do
        mock_user.stub!(:style).and_return(mock_style(:update_attributes => true))
        mock_user.should_receive(:subdomain).and_return('test_subdomain')
        put :update, :id => "1"
        assigns(:style).should equal(mock_style)
      end

      it "should redirect to the style" do
        mock_user.stub!(:style).and_return(mock_style(:update_attributes => true))
        mock_user.should_receive(:subdomain).and_return('test_subdomain')
        put :update, :id => "1"
        response.should redirect_to(projects_root_url(:subdomain => 'test_subdomain'))
      end
    end
    
    describe "with invalid params" do
      it "should update the requested style" do
        mock_user.should_receive(:style).with(no_args).and_return(mock_style)
        mock_style.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :style => {:these => 'params'}
      end

      it "should expose the style as @style" do
        mock_user.stub!(:style).and_return(mock_style(:update_attributes => false))
        put :update, :id => "1"
        assigns(:style).should equal(mock_style)
      end

      it "should re-render the 'edit' template" do
        mock_user.stub!(:style).and_return(mock_style(:update_attributes => false))
        put :update, :id => "1"
        response.should render_template('edit')
      end
    end
  end
end
