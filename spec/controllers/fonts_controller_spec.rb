require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe FontsController do

  def mock_font(stubs={})
    @mock_font ||= mock_model(Font, stubs)
  end
  
  describe "GET index" do

    it "exposes all fonts as @fonts" do
      Font.should_receive(:find).with(:all).and_return([mock_font])
      get :index
      assigns[:fonts].should == [mock_font]
    end

    describe "with mime type of xml" do
  
      it "renders all fonts as xml" do
        Font.should_receive(:find).with(:all).and_return(fonts = mock("Array of Fonts"))
        fonts.should_receive(:to_xml).and_return("generated XML")
        get :index, :format => 'xml'
        response.body.should == "generated XML"
      end
    
    end

  end

  describe "GET show" do

    it "exposes the requested font as @font" do
      Font.should_receive(:find).with("37").and_return(mock_font)
      get :show, :id => "37"
      assigns[:font].should equal(mock_font)
    end
    
    describe "with mime type of xml" do

      it "renders the requested font as xml" do
        Font.should_receive(:find).with("37").and_return(mock_font)
        mock_font.should_receive(:to_xml).and_return("generated XML")
        get :show, :id => "37", :format => 'xml'
        response.body.should == "generated XML"
      end

    end
    
  end

  describe "GET new" do
  
    it "exposes a new font as @font" do
      Font.should_receive(:new).and_return(mock_font)
      get :new
      assigns[:font].should equal(mock_font)
    end

  end

  describe "GET edit" do
  
    it "exposes the requested font as @font" do
      Font.should_receive(:find).with("37").and_return(mock_font)
      get :edit, :id => "37"
      assigns[:font].should equal(mock_font)
    end

  end

  describe "POST create" do

    describe "with valid params" do
      
      it "exposes a newly created font as @font" do
        Font.should_receive(:new).with({'these' => 'params'}).and_return(mock_font(:save => true))
        post :create, :font => {:these => 'params'}
        assigns(:font).should equal(mock_font)
      end

      it "redirects to the created font" do
        Font.stub!(:new).and_return(mock_font(:save => true))
        post :create, :font => {}
        response.should redirect_to(font_url(mock_font))
      end
      
    end
    
    describe "with invalid params" do

      it "exposes a newly created but unsaved font as @font" do
        Font.stub!(:new).with({'these' => 'params'}).and_return(mock_font(:save => false))
        post :create, :font => {:these => 'params'}
        assigns(:font).should equal(mock_font)
      end

      it "re-renders the 'new' template" do
        Font.stub!(:new).and_return(mock_font(:save => false))
        post :create, :font => {}
        response.should render_template('new')
      end
      
    end
    
  end

  describe "PUT udpate" do

    describe "with valid params" do

      it "updates the requested font" do
        Font.should_receive(:find).with("37").and_return(mock_font)
        mock_font.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :font => {:these => 'params'}
      end

      it "exposes the requested font as @font" do
        Font.stub!(:find).and_return(mock_font(:update_attributes => true))
        put :update, :id => "1"
        assigns(:font).should equal(mock_font)
      end

      it "redirects to the font" do
        Font.stub!(:find).and_return(mock_font(:update_attributes => true))
        put :update, :id => "1"
        response.should redirect_to(font_url(mock_font))
      end

    end
    
    describe "with invalid params" do

      it "updates the requested font" do
        Font.should_receive(:find).with("37").and_return(mock_font)
        mock_font.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :font => {:these => 'params'}
      end

      it "exposes the font as @font" do
        Font.stub!(:find).and_return(mock_font(:update_attributes => false))
        put :update, :id => "1"
        assigns(:font).should equal(mock_font)
      end

      it "re-renders the 'edit' template" do
        Font.stub!(:find).and_return(mock_font(:update_attributes => false))
        put :update, :id => "1"
        response.should render_template('edit')
      end

    end

  end

  describe "DELETE destroy" do

    it "destroys the requested font" do
      Font.should_receive(:find).with("37").and_return(mock_font)
      mock_font.should_receive(:destroy)
      delete :destroy, :id => "37"
    end
  
    it "redirects to the fonts list" do
      Font.stub!(:find).and_return(mock_font(:destroy => true))
      delete :destroy, :id => "1"
      response.should redirect_to(fonts_url)
    end

  end

end
