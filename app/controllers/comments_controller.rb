class CommentsController < ApplicationController
  layout "promotional"
  skip_filter :load_profile
  
  before_filter :load_article
  
  protected
  
  def load_article
    @article = Article.find(params[:article_id])
  end
  
  public
  
  def create
    @comment = @article.comments.build(params[:comment])
    
    if @comment.save
      flash[:notice] = "Thank you for your comment"
      redirect_to(article_path(@article))
    else
      render :template => "articles/show"
    end
  end
end
