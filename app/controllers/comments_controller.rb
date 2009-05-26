class CommentsController < PromotionalController
    
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
      respond_to do |format|
        format.html {redirect_to(article_path(@article))}
        format.js
      end
    else
      render :template => "articles/show"
    end
  end
  
  def destroy
    @comment = @article.comments.find(params[:id])
    @comment.destroy
    flash[:notice] = "Successfully destroyed comment"
    redirect_to article_path(@article)
  end
end
