class DraftArticlesController < PromotionalController
  require_role :admin
    
  def index
    @articles = Article.draft
  end
  
  def new
    @article = Article.new
  end
  
  def create
    @article = Article.new(params[:article])
    
    if @article.save
      flash[:notice] = "Successfully created draft article"
      redirect_to article_path(@article)
    else
      render :action => 'new'
    end
  end
  
  def publish
    @article = Article.find(params[:id])
    
    if @article.publish!
      flash[:notice] = "Successfully published article"
      redirect_to article_path(@article)
    else
      flash[:warning] = "There was an error publishing the article"
      redirect_to article_path(@article)
    end
  end
end
