require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ThemesController do

  def mock_theme(stubs={})
    @mock_theme ||= mock_model(Theme, stubs)
  end
  
  describe "responding to GET index" do

    it "should expose all themes as @themes" do
      Theme.should_receive(:find).with(:all).and_return([mock_theme])
      get :index
      assigns[:themes].should == [mock_theme]
    end

    describe "with mime type of xml" do
  
      it "should render all themes as xml" do
        request.env["HTTP_ACCEPT"] = "application/xml"
        Theme.should_receive(:find).with(:all).and_return(themes = mock("Array of Themes"))
        themes.should_receive(:to_xml).and_return("generated XML")
        get :index
        response.body.should == "generated XML"
      end
    
    end

  end

  describe "responding to GET show" do

    it "should expose the requested theme as @theme" do
      Theme.should_receive(:find).with("37").and_return(mock_theme)
      get :show, :id => "37"
      assigns[:theme].should equal(mock_theme)
    end
    
    describe "with mime type of xml" do

      it "should render the requested theme as xml" do
        request.env["HTTP_ACCEPT"] = "application/xml"
        Theme.should_receive(:find).with("37").and_return(mock_theme)
        mock_theme.should_receive(:to_xml).and_return("generated XML")
        get :show, :id => "37"
        response.body.should == "generated XML"
      end

    end
    
  end

  describe "responding to GET new" do
  
    it "should expose a new theme as @theme" do
      Theme.should_receive(:new).and_return(mock_theme)
      get :new
      assigns[:theme].should equal(mock_theme)
    end

  end

  describe "responding to GET edit" do
  
    it "should expose the requested theme as @theme" do
      Theme.should_receive(:find).with("37").and_return(mock_theme)
      get :edit, :id => "37"
      assigns[:theme].should equal(mock_theme)
    end

  end

  describe "responding to POST create" do

    describe "with valid params" do
      
      it "should expose a newly created theme as @theme" do
        Theme.should_receive(:new).with({'these' => 'params'}).and_return(mock_theme(:save => true))
        post :create, :theme => {:these => 'params'}
        assigns(:theme).should equal(mock_theme)
      end

      it "should redirect to the created theme" do
        Theme.stub!(:new).and_return(mock_theme(:save => true))
        post :create, :theme => {}
        response.should redirect_to(theme_url(mock_theme))
      end
      
    end
    
    describe "with invalid params" do

      it "should expose a newly created but unsaved theme as @theme" do
        Theme.stub!(:new).with({'these' => 'params'}).and_return(mock_theme(:save => false))
        post :create, :theme => {:these => 'params'}
        assigns(:theme).should equal(mock_theme)
      end

      it "should re-render the 'new' template" do
        Theme.stub!(:new).and_return(mock_theme(:save => false))
        post :create, :theme => {}
        response.should render_template('new')
      end
      
    end
    
  end

  describe "responding to PUT udpate" do

    describe "with valid params" do

      it "should update the requested theme" do
        Theme.should_receive(:find).with("37").and_return(mock_theme)
        mock_theme.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :theme => {:these => 'params'}
      end

      it "should expose the requested theme as @theme" do
        Theme.stub!(:find).and_return(mock_theme(:update_attributes => true))
        put :update, :id => "1"
        assigns(:theme).should equal(mock_theme)
      end

      it "should redirect to the theme" do
        Theme.stub!(:find).and_return(mock_theme(:update_attributes => true))
        put :update, :id => "1"
        response.should redirect_to(theme_url(mock_theme))
      end

    end
    
    describe "with invalid params" do

      it "should update the requested theme" do
        Theme.should_receive(:find).with("37").and_return(mock_theme)
        mock_theme.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :theme => {:these => 'params'}
      end

      it "should expose the theme as @theme" do
        Theme.stub!(:find).and_return(mock_theme(:update_attributes => false))
        put :update, :id => "1"
        assigns(:theme).should equal(mock_theme)
      end

      it "should re-render the 'edit' template" do
        Theme.stub!(:find).and_return(mock_theme(:update_attributes => false))
        put :update, :id => "1"
        response.should render_template('edit')
      end

    end

  end

  describe "responding to DELETE destroy" do

    it "should destroy the requested theme" do
      Theme.should_receive(:find).with("37").and_return(mock_theme)
      mock_theme.should_receive(:destroy)
      delete :destroy, :id => "37"
    end
  
    it "should redirect to the themes list" do
      Theme.stub!(:find).and_return(mock_theme(:destroy => true))
      delete :destroy, :id => "1"
      response.should redirect_to(themes_url)
    end

  end

end
