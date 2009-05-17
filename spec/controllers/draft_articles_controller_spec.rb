require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe DraftArticlesController do
  
  def mock_draft_article(stubs={})
    @mock_draft_article ||= mock_model(Article, stubs)
  end
  
  describe "responding to a GET index" do
    it "expose all draft articles as @draft_articles" do
      Article.should_receive(:draft).and_return([mock_draft_article])
      get :index
      assigns[:articles].should == [mock_draft_article]
    end
  end
  
  describe "responding to a GET new" do
    it "should expose a new article as @draft_article" do
      Article.should_receive(:new).and_return(mock_draft_article)
      get :new
      assigns[:article].should == mock_draft_article
    end
  end
  
  describe "responding to a POST create" do
    describe "with valid parameters" do
      it "should create a new draft article" do
        Article.should_receive(:new).with({'these' => 'params'}).and_return(mock_draft_article(:save => true))
        post :create, :article => {'these' => 'params'}
        assigns[:article].should == mock_draft_article
        flash[:notice].should == "Successfully created draft article"
      end
    
      it "should redirect to article show page" do
        Article.stub!(:new).and_return(mock_draft_article(:save => true))
        post :create, :article => {}
        response.should redirect_to(article_path(mock_draft_article))
      end
    end
    
    describe "with invalid parameters" do
      it "should expose the unsaved, invalid article as @article" do
        Article.should_receive(:new).with({'these' => 'invalid params'}).and_return(mock_draft_article(:save => false))
        post :create, :article => {'these' => 'invalid params'}
        assigns[:article].should == mock_draft_article
      end
      
      it "should re-render the form" do
        Article.stub!(:new).and_return(mock_draft_article(:save => false))
        post :create, :article => {}
        response.should render_template('new')
      end
    end
  end
  
  describe "responding to a PUT publish" do
    describe "succesfully publishing the article" do
      it "should expose the newly published article as @article and display the articles" do
        Article.should_receive(:find).with("1").and_return(mock_draft_article(:publish! => true))
        put :publish, :id => "1"
        assigns[:article].should == mock_draft_article
        response.should redirect_to(article_path(mock_draft_article))
      end
    end
    
    describe "failing to publish the article" do
      it "should redirect to the article show page" do
        Article.should_receive(:find).with("1").and_return(mock_draft_article(:publish! => false))
        put :publish, :id => "1"
        assigns[:article].should == mock_draft_article
        flash[:warning].should == "There was an error publishing the article"
        response.should redirect_to(article_path(mock_draft_article))
      end
    end
  end
end
