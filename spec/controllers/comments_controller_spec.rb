require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe CommentsController do
  
  def mock_article(stubs={})
    @mock_article ||= mock_model(Article, stubs)
  end
  
  def mock_comment(stubs={})
    @mock_comment ||= mock_model(Comment, stubs)
  end
  
  before(:each) do
    Article.stub!(:find).and_return(mock_article(:comments => [mock_comment]))
  end
  
  # describe "scoping the actions to an article" do
  #   it "should expose the article as @article" do
  #     Article.should_receive(:find).with("1").and_return(mock_article(:comments => [mock_comment]))
  #     post :create, :article_id => "1"
  #     assigns[:article].should == mock_article
  #   end
  # end
  
  describe "responding to a POST create" do
    describe "with valid parameters" do
      it "should create a new comment" do
        mock_article.comments.should_receive(:build).with({'these' => 'params'}).and_return(mock_comment(:save => true))
        mock_comment.stub!(:save).and_return(true)
        post :create, :article_id => "1", :comment => {"these" => "params"}
        assigns[:comment].should == mock_comment
      end
      
      it "should redirect to the article page" do
        mock_article.comments.stub!(:build).and_return(mock_comment(:save => true))
        mock_comment.stub!(:save).and_return(true)
        post :create, :article_id => "1"
        response.should redirect_to(article_path(mock_article))
      end
    end
    
    describe "with invalid parameters" do
      it "should expose an unsaved instance of comment as @comment" do
        mock_article.comments.should_receive(:build).and_return(mock_comment(:save => false))
        mock_comment.stub!(:save).and_return(false) # not sure why but rspec is complaining that this isn't being specd
        post :create, :article_id => "1"
        assigns[:comment].should == mock_comment
      end
      
      it "should re-render the form" do
        mock_article.comments.should_receive(:build).and_return(mock_comment(:save => false))
        mock_comment.stub!(:save).and_return(false) # not sure why but rspec is complaining that this isn't being specd
        post :create, :article_id => "1"
        response.should render_template('articles/show')
      end
    end
  end
end
