require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ProfilesController do

  before(:each) do
    # using 'test' as this is what the subdomain is when running the tests
    User.stub!(:find_by_subdomain).with("test").and_return(mock_user)
  end
  
  def mock_user(stubs={})
    @mock_user ||= mock_model(User, stubs.reverse_merge(:profile => mock('Profile')))
  end

  def mock_profile(stubs={})
    @mock_profile ||= mock_model(Profile, stubs)
  end

  describe "scoping the actions to a user" do
    it "should expose the user as @user" do
      User.should_receive(:find_by_subdomain).with("test").and_return(mock_user)
      get :show, :id => "37"
      assigns[:user].should == mock_user
    end
  end
  
  describe "handling an unrecognized subdomain" do
    it "should redirect to the root url" do
      User.stub!(:find_by_subdomain).with("test").and_return(false)
      get :show, :id => "37"
      response.should redirect_to(root_url)
    end
  end

  describe "responding to GET show" do
    it "should expose the requested profile as @profile" do
      mock_user.should_receive(:profile).with(no_args).and_return(mock_profile)
      get :show, :id => "37"
      assigns[:profile].should equal(mock_profile)
    end
    
    describe "with mime type of xml" do
      it "should render the requested profile as xml" do
        request.env["HTTP_ACCEPT"] = "application/xml"
        mock_user.should_receive(:profile).with(no_args).and_return(mock_profile)
        mock_profile.should_receive(:to_xml).and_return("generated XML")
        get :show, :id => "37"
        response.body.should == "generated XML"
      end
    end
  end

  describe "responding to GET edit" do
    it "should expose the requested profile as @profile" do
      mock_user.should_receive(:profile).with(no_args).and_return(mock_profile)
      get :edit, :id => "37"
      assigns[:profile].should equal(mock_profile)
    end
  end

  
  describe "responding to PUT udpate" do
    describe "with valid params" do
      it "should update the requested profile" do
        mock_user.should_receive(:profile).with(no_args).and_return(mock_profile)
        mock_profile.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :profile => {:these => 'params'}
      end

      it "should expose the requested profile as @profile" do
        mock_user.stub!(:profile).and_return(mock_profile(:update_attributes => true))
        mock_user.should_receive(:subdomain).and_return('user_subdomain')
        put :update, :id => "1"
        assigns(:profile).should equal(mock_profile)
      end

      it "should redirect to the profile" do
        mock_user.stub!(:profile).and_return(mock_profile(:update_attributes => true))
        mock_user.should_receive(:subdomain).and_return('user_subdomain')
        put :update, :id => "1"
        response.should redirect_to(project_url(:subdomain => 'user_subdomain'))
      end
    end
    
    describe "with invalid params" do
      it "should update the requested profile" do
        mock_user.should_receive(:profile).with(no_args).and_return(mock_profile)
        mock_profile.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :profile => {:these => 'params'}
      end

      it "should expose the profile as @profile" do
        mock_user.stub!(:profile).and_return(mock_profile(:update_attributes => false))
        put :update, :id => "1"
        assigns(:profile).should equal(mock_profile)
      end

      it "should re-render the 'edit' template" do
        mock_user.stub!(:profile).and_return(mock_profile(:update_attributes => false))
        put :update, :id => "1"
        response.should render_template('edit')
      end
    end
  end
end
