require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe PlansController do
  
  # TODO: need to test that the controller is only accessabile to the admin user

  def mock_plan(stubs={})
    @mock_plan ||= mock_model(Plan, stubs)
  end
  
  def mock_admin_user(stubs={})
    @mock_admin_user ||= mock_model(User, :roles => [mock_admin_role])
  end
  
  def mock_basic_user(stubs={})
    @mock_basic_user ||= mock_model(User, :roles => [mock_basic_role])
  end
  
  def mock_admin_role
    @mock_admin_role ||= mock_model(Role, :name => 'admin')
  end
  
  def mock_basic_role
    @mock_basic_role ||= mock_model(Role, :name => 'basic')
  end
  
  describe "responding to GET index" do
    describe "as an admin role" do
      it "should expose all plans as @plans" do
        controller.should_receive(:current_user).and_return(mock_admin_user)
        mock_admin_user.should_receive(:has_role?).and_return(true)
        Plan.should_receive(:find).with(:all).and_return([mock_plan])
        get :index
        assigns[:plans].should == [mock_plan]
      end

      describe "with mime type of xml" do
        it "should render all plans as xml" do
          request.env["HTTP_ACCEPT"] = "application/xml"
          controller.should_receive(:current_user).and_return(mock_admin_user)
          mock_admin_user.should_receive(:has_role?).and_return(true)
          Plan.should_receive(:find).with(:all).and_return(plans = mock("Array of Plans"))
          plans.should_receive(:to_xml).and_return("generated XML")
          get :index
          response.body.should == "generated XML"
        end
      end
    end
    
    describe "as a basic role" do
      it "should redirect to the login path" do
        controller.should_receive(:current_user).and_return(mock_basic_user)
        mock_basic_user.should_receive(:has_role?).and_return(false)
        get :index
        response.should redirect_to(login_path)
      end
    end
  end
  
  describe "responding to GET show" do
    it "should expose the requested plan as @plan" do
      controller.should_receive(:current_user).and_return(mock_admin_user)
      mock_admin_user.should_receive(:has_role?).and_return(true)
      Plan.should_receive(:find_by_name).with("name").and_return(mock_plan)
      get :show, :id => "name"
      assigns[:plan].should equal(mock_plan)
    end
    
    describe "with mime type of xml" do
      it "should render the requested plan as xml" do
        request.env["HTTP_ACCEPT"] = "application/xml"
        controller.should_receive(:current_user).and_return(mock_admin_user)
        mock_admin_user.should_receive(:has_role?).and_return(true)
        Plan.should_receive(:find_by_name).with("name").and_return(mock_plan)
        mock_plan.should_receive(:to_xml).and_return("generated XML")
        get :show, :id => "name"
        response.body.should == "generated XML"
      end
    end
    
    describe "as a basic role" do
      it "should redirect to the login path" do
        controller.should_receive(:current_user).and_return(mock_basic_user)
        mock_basic_user.should_receive(:has_role?).and_return(false)
        get :show, :id => "37"
        response.should redirect_to(login_path)
      end
    end
  end

  describe "responding to GET new" do
    it "should expose a new plan as @plan" do
      controller.should_receive(:current_user).and_return(mock_admin_user)
      mock_admin_user.should_receive(:has_role?).and_return(true)
      Plan.should_receive(:new).and_return(mock_plan)
      get :new
      assigns[:plan].should equal(mock_plan)
    end
    
    describe "as a basic role" do
      it "should redirect to the login path" do
        controller.should_receive(:current_user).and_return(mock_basic_user)
        mock_basic_user.should_receive(:has_role?).and_return(false)
        get :new
        response.should redirect_to(login_path)
      end
    end
  end

  describe "responding to GET edit" do
    it "should expose the requested plan as @plan" do
      controller.should_receive(:current_user).and_return(mock_admin_user)
      mock_admin_user.should_receive(:has_role?).and_return(true)
      Plan.should_receive(:find_by_name).with("name").and_return(mock_plan)
      get :edit, :id => "name"
      assigns[:plan].should equal(mock_plan)
    end
    
    describe "as a basic role" do
      it "should redirect to the login path" do
        controller.should_receive(:current_user).and_return(mock_basic_user)
        mock_basic_user.should_receive(:has_role?).and_return(false)
        get :edit, :id => "name"
        response.should redirect_to(login_path)
      end
    end
  end

  describe "responding to POST create" do
    describe "with valid params" do
      it "should expose a newly created plan as @plan" do
        controller.should_receive(:current_user).and_return(mock_admin_user)
        mock_admin_user.should_receive(:has_role?).and_return(true)
        Plan.should_receive(:new).with({'these' => 'params'}).and_return(mock_plan(:save => true))
        post :create, :plan => {:these => 'params'}
        assigns(:plan).should equal(mock_plan)
      end

      it "should redirect to the created plan" do
        controller.should_receive(:current_user).and_return(mock_admin_user)
        mock_admin_user.should_receive(:has_role?).and_return(true)
        Plan.stub!(:new).and_return(mock_plan(:save => true))
        post :create, :plan => {}
        response.should redirect_to(plan_url(mock_plan))
      end
    end
    
    describe "with invalid params" do
      it "should expose a newly created but unsaved plan as @plan" do
        controller.should_receive(:current_user).and_return(mock_admin_user)
        mock_admin_user.should_receive(:has_role?).and_return(true)
        Plan.stub!(:new).with({'these' => 'params'}).and_return(mock_plan(:save => false))
        post :create, :plan => {:these => 'params'}
        assigns(:plan).should equal(mock_plan)
      end

      it "should re-render the 'new' template" do
        controller.should_receive(:current_user).and_return(mock_admin_user)
        mock_admin_user.should_receive(:has_role?).and_return(true)
        Plan.stub!(:new).and_return(mock_plan(:save => false))
        post :create, :plan => {}
        response.should render_template('new')
      end      
    end
    
    describe "as a basic role" do
      it "should redirect to the login path" do
        controller.should_receive(:current_user).and_return(mock_basic_user)
        mock_basic_user.should_receive(:has_role?).and_return(false)
        post :create, :plan => {:these => 'params'}
        response.should redirect_to(login_path)
      end
    end    
  end

  describe "responding to PUT udpate" do
    describe "with valid params" do
      it "should update the requested plan" do
        controller.should_receive(:current_user).and_return(mock_admin_user)
        mock_admin_user.should_receive(:has_role?).and_return(true)
        Plan.should_receive(:find_by_name).with("name").and_return(mock_plan)
        mock_plan.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "name", :plan => {'these' => 'params'}
      end

      it "should expose the requested plan as @plan" do
        controller.should_receive(:current_user).and_return(mock_admin_user)
        mock_admin_user.should_receive(:has_role?).and_return(true)
        Plan.stub!(:find_by_name).and_return(mock_plan(:update_attributes => true))
        put :update, :id => "1"
        assigns(:plan).should equal(mock_plan)
      end

      it "should redirect to the plan" do
        controller.should_receive(:current_user).and_return(mock_admin_user)
        mock_admin_user.should_receive(:has_role?).and_return(true)
        Plan.stub!(:find_by_name).and_return(mock_plan(:update_attributes => true))
        put :update, :id => "1"
        response.should redirect_to(plan_url(mock_plan))
      end
    end
    
    describe "with invalid params" do
      it "should update the requested plan" do
        controller.should_receive(:current_user).and_return(mock_admin_user)
        mock_admin_user.should_receive(:has_role?).and_return(true)
        Plan.should_receive(:find_by_name).with("name").and_return(mock_plan)
        mock_plan.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "name", :plan => {:these => 'params'}
      end

      it "should expose the plan as @plan" do
        controller.should_receive(:current_user).and_return(mock_admin_user)
        mock_admin_user.should_receive(:has_role?).and_return(true)
        Plan.stub!(:find_by_name).and_return(mock_plan(:update_attributes => false))
        put :update, :id => "name"
        assigns(:plan).should equal(mock_plan)
      end

      it "should re-render the 'edit' template" do
        controller.should_receive(:current_user).and_return(mock_admin_user)
        mock_admin_user.should_receive(:has_role?).and_return(true)
        Plan.stub!(:find_by_name).and_return(mock_plan(:update_attributes => false))
        put :update, :id => "name"
        response.should render_template('edit')
      end
    end
    
    describe "as a basic role" do
      it "should redirect to the login path" do
        controller.should_receive(:current_user).and_return(mock_basic_user)
        mock_basic_user.should_receive(:has_role?).and_return(false)
        put :update, :id => "37", :plan => {:these => 'params'}
        response.should redirect_to(login_path)
      end
    end
  end

  describe "responding to DELETE destroy" do
    it "should destroy the requested plan" do
      controller.should_receive(:current_user).and_return(mock_admin_user)
      mock_admin_user.should_receive(:has_role?).and_return(true)
      Plan.should_receive(:find_by_name).with("name").and_return(mock_plan)
      mock_plan.should_receive(:destroy)
      delete :destroy, :id => "name"
    end
  
    it "should redirect to the plans list" do
      controller.should_receive(:current_user).and_return(mock_admin_user)
      mock_admin_user.should_receive(:has_role?).and_return(true)
      Plan.stub!(:find_by_name).and_return(mock_plan(:destroy => true))
      delete :destroy, :id => "name"
      response.should redirect_to(plans_url)
    end
    
    describe "as a basic role" do
      it "should redirect to the login path" do
        controller.should_receive(:current_user).and_return(mock_basic_user)
        mock_basic_user.should_receive(:has_role?).and_return(false)
        delete :destroy, :id => "37"
        response.should redirect_to(login_path)
      end
    end
  end
end
