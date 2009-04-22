require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe PagesController do
  
  before(:each) do
    controller.stub!(:load_profile).and_return(true)
    User.stub!(:find_by_subdomain).with("test").and_return(mock_user)
  end
  
  def mock_page(stubs={})
    @mock_page ||= mock_model(Page, stubs)
  end
  
  def mock_user(stubs={})
    @mock_user ||= mock_model(User, stubs.reverse_merge(:pages => mock('Array of Pages')))
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
  
  describe "GET index" do
    it "exposes all pages as @pages" do
      mock_user.should_receive(:pages).and_return([mock_page])
      get :index
      assigns[:pages].should == [mock_page]
    end

    describe "with mime type of xml" do
      it "renders all pages as xml" do
        mock_user.should_receive(:pages).and_return(pages = mock("Array of Pages"))
        pages.should_receive(:to_xml).and_return("generated XML")
        get :index, :format => 'xml'
        response.body.should == "generated XML"
      end
    end
  end

  describe "GET show" do
    it "exposes the requested page as @page" do
      mock_user.pages.should_receive(:find_by_permalink).with("about_me").and_return(mock_page)
      get :show, :id => "about_me"
      assigns[:page].should equal(mock_page)
    end
    
    describe "with mime type of xml" do
      it "renders the requested page as xml" do
        mock_user.pages.should_receive(:find_by_permalink).with("about_me").and_return(mock_page)
        mock_page.should_receive(:to_xml).and_return("generated XML")
        get :show, :id => "about_me", :format => 'xml'
        response.body.should == "generated XML"
      end
    end 
  end

  describe "GET new" do
    it "exposes a new page as @page" do
      mock_user.pages.should_receive(:build).and_return(mock_page)
      get :new
      assigns[:page].should equal(mock_page)
    end
  end

  describe "GET edit" do
    it "exposes the requested page as @page" do
      mock_user.pages.should_receive(:find_by_permalink).with("about_me").and_return(mock_page)
      get :edit, :id => "about_me"
      assigns[:page].should equal(mock_page)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "exposes a newly created page as @page" do
        mock_user.pages.should_receive(:build).with({'these' => 'params'}).and_return(mock_page(:save => true))
        post :create, :page => {:these => 'params'}
        assigns(:page).should equal(mock_page)
      end

      it "redirects to the created page" do
        mock_user.pages.stub!(:build).and_return(mock_page(:save => true))
        post :create, :page => {}
        response.should redirect_to(page_url(mock_page))
      end
    end
    
    describe "with invalid params" do
      it "exposes a newly created but unsaved page as @page" do
        mock_user.pages.stub!(:build).with({'these' => 'params'}).and_return(mock_page(:save => false))
        post :create, :page => {:these => 'params'}
        assigns(:page).should equal(mock_page)
      end

      it "re-renders the 'new' template" do
        mock_user.pages.stub!(:build).and_return(mock_page(:save => false))
        post :create, :page => {}
        response.should render_template('new')
      end
    end
  end

  describe "PUT udpate" do
    describe "with valid params" do
      it "updates the requested page" do
        mock_user.pages.should_receive(:find_by_permalink).with("about_me").and_return(mock_page)
        mock_page.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "about_me", :page => {:these => 'params'}
      end

      it "exposes the requested page as @page" do
        mock_user.pages.stub!(:find_by_permalink).and_return(mock_page(:update_attributes => true))
        put :update, :id => "about_me"
        assigns(:page).should equal(mock_page)
      end

      it "redirects to the page" do
        mock_user.pages.stub!(:find_by_permalink).and_return(mock_page(:update_attributes => true))
        put :update, :id => "about_me"
        response.should redirect_to(page_url(mock_page))
      end
    end
    
    describe "with invalid params" do
      it "updates the requested page" do
        mock_user.pages.should_receive(:find_by_permalink).with("about_me").and_return(mock_page)
        mock_page.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "about_me", :page => {:these => 'params'}
      end

      it "exposes the page as @page" do
        mock_user.pages.stub!(:find_by_permalink).and_return(mock_page(:update_attributes => false))
        put :update, :id => "about_me"
        assigns(:page).should equal(mock_page)
      end

      it "re-renders the 'edit' template" do
        mock_user.pages.stub!(:find_by_permalink).and_return(mock_page(:update_attributes => false))
        put :update, :id => "about_me"
        response.should render_template('edit')
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested page" do
      mock_user.pages.should_receive(:find_by_permalink).with("about_me").and_return(mock_page)
      mock_page.should_receive(:destroy)
      delete :destroy, :id => "about_me"
    end
  
    it "redirects to the pages list" do
      mock_user.pages.stub!(:find_by_permalink).and_return(mock_page(:destroy => true))
      delete :destroy, :id => "about_me"
      response.should redirect_to(pages_url)
    end
  end
end
