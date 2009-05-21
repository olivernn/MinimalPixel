require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ArticlesController do
  
  def mock_article(stubs={})
    @mock_article ||= mock_model(Article, stubs)
  end
  
  def mock_comment(stubs={})
    @mock_comment ||= mock_model(Comment, stubs)
  end
  
  describe "responding to a GET index" do
    it "expose all published articles as @articles, with 5 per page" do
      # Article.should_receive(:active).and_return([mock_article])
      Article.active.should_receive(:paginate).with(:per_page => 5, :page => 1).and_return([mock_article])
      get :index
      # assigns[:articles].should eql([mock_article])
      [mock_article].size.should <= 5
    end
  end
  
  describe "responding to a GET show" do
    it "should expose the requested article as @article" do
      Article.should_receive(:find).with("1").and_return(mock_article(:comments => [mock_comment]))
      get :show, :id => "1"
      assigns[:article].should == mock_article
    end
    
    it "should expose a new comment as @comment" do
      Article.stub!(:find).and_return(mock_article(:comments => [mock_comment]))
      Comment.should_receive(:new).and_return(mock_comment)
      get :show, :id => "1"
      assigns[:comment].should == mock_comment
    end
    
    it "should expose all the articles comments as @comments" do
      Article.stub!(:find).and_return(mock_article)
      Comment.stub!(:new).and_return(mock_comment)
      mock_article.should_receive(:comments).and_return([mock_comment])
      get :show, :id => "1"
      assigns[:comments].should == [mock_comment]
    end
  end
  
  describe "responding to a GET edit" do
    it "should expose an existing article as @article" do
      Article.should_receive(:find).with("1").and_return(mock_article)
      get :edit, :id => "1"
      assigns[:article].should == mock_article
    end
  end
  
  describe "responding to a PUT update" do
    describe "with valid parameters" do
      it "should update an existing article" do
        Article.should_receive(:find).with("1").and_return(mock_article(:update_attributes => true))
        put :update, :id => "1"
        assigns[:article].should == mock_article
        flash[:notice].should == "Successfully updated article"
      end
      
      it "should redirect to the article show page" do
        Article.stub!(:find).and_return(mock_article(:update_attributes => true))
        put :update, :id => "1"
        response.should redirect_to(article_path(mock_article))
      end
    end
    
    describe "with invalid parameters" do
      it "should not update the the article" do
        Article.should_receive(:find).with("1").and_return(mock_article(:update_attributes => false))
        put :update, :id => "1"
        assigns[:article].should == mock_article
      end
      
      it "should re-render the edit form" do
        Article.stub!(:find).and_return(mock_article(:update_attributes => false))
        put :update, :id => "1"
        response.should render_template('edit')
      end
    end
  end
  
  describe "responding to a DELETE destroy" do
    it "should destroy the required article" do
      Article.should_receive(:find).with("1").and_return(mock_article)
      mock_article.should_receive(:destroy)
      delete :destroy, :id => "1"
      assigns[:article].should == mock_article
      flash[:notice].should == "Succesfully destroyed article"
      response.should redirect_to(articles_path)
    end
  end
end
