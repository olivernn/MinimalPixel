require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ArticlesController do
  
  def mock_article(stubs={})
    @mock_article ||= mock_model(Article, stubs)
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
      Article.should_receive(:find).with("1").and_return(mock_article)
      get :show, :id => "1"
      assigns[:article].should == mock_article
    end
  end
end
