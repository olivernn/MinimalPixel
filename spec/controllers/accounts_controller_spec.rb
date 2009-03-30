require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe AccountsController do
  
  before(:each) do
    # using 'test' as this is what the subdomain is when running the tests
    User.stub!(:find_by_subdomain).with("test").and_return(mock_user)
  end
  
  def mock_user(stubs={})
    @mock_user ||= mock_model(User, stubs.reverse_merge(:account => mock('Account')))
  end
  
  def mock_account(stubs={})
    @mock_account ||= mock_model(Account, stubs)
  end
  
  def mock_plan(stubs={})
    @mock_plan ||= mock_model(Plan, stubs.reverse_merge(:accounts => mock('Array of Accounts')))    
  end
  
  describe "scoping the actions to a user" do
    it "should expose the user as @user" do
      User.should_receive(:find_by_subdomain).with("test").and_return(mock_user)
      get :show, :id => 1
      assigns[:user].should == mock_user
    end
  end
  
  describe "handling an unrecognized subdomain" do
    it "should redirect to the root url" do
      User.stub!(:find_by_subdomain).with("test").and_return(false)
      get :show, :id => 1
      response.should redirect_to(root_url)
    end
  end
  
  describe "responding to GET show" do
    it "should expose the requested account as @account" do
      Account.should_receive(:find).with("37").and_return(mock_account)
      get :show, :id => "37"
      assigns[:account].should equal(mock_account)
    end
    
    describe "with mime type of xml" do
      it "should render the requested account as xml" do
        request.env["HTTP_ACCEPT"] = "application/xml"
        Account.should_receive(:find).with("37").and_return(mock_account)
        mock_account.should_receive(:to_xml).and_return("generated XML")
        get :show, :id => "37"
        response.body.should == "generated XML"
      end
    end
  end

  describe "responding to GET edit" do
    it "should expose the requested account as @account" do
      Account.should_receive(:find).with("37").and_return(mock_account)
      get :edit, :id => "37"
      assigns[:account].should equal(mock_account)
    end
  end

  describe "responding to PUT udpate" do
    describe "with valid params" do
      it "should update the requested account" do
        Account.should_receive(:find).with("37").and_return(mock_account)
        mock_account.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :account => {:these => 'params'}
      end

      it "should expose the requested account as @account" do
        Account.stub!(:find).and_return(mock_account(:update_attributes => true))
        put :update, :id => "1"
        assigns(:account).should equal(mock_account)
      end

      it "should redirect to the account" do
        Account.stub!(:find).and_return(mock_account(:update_attributes => true))
        put :update, :id => "1"
        response.should redirect_to(account_url(mock_account))
      end
    end
    
    describe "with invalid params" do
      it "should update the requested account" do
        Account.should_receive(:find).with("37").and_return(mock_account)
        mock_account.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :account => {:these => 'params'}
      end

      it "should expose the account as @account" do
        Account.stub!(:find).and_return(mock_account(:update_attributes => false))
        put :update, :id => "1"
        assigns(:account).should equal(mock_account)
      end

      it "should re-render the 'edit' template" do
        Account.stub!(:find).and_return(mock_account(:update_attributes => false))
        put :update, :id => "1"
        response.should render_template('edit')
      end
    end
  end

  describe "responding to DELETE destroy" do
    it "should destroy the requested account" do
      Account.should_receive(:find).with("37").and_return(mock_account)
      mock_account.should_receive(:destroy)
      delete :destroy, :id => "37"
    end
  
    it "should redirect to the accounts list" do
      Account.stub!(:find).and_return(mock_account(:destroy => true))
      delete :destroy, :id => "1"
      response.should redirect_to(accounts_url)
    end
  end
end
