class ArticlesController < ApplicationController
  layout "promotional"
  skip_filter :load_profile
  
  def index
    @articles = Article.active.paginate(:per_page => 5, :page => params[:page])
  end
  
  def show
    @article = Article.find(params[:id])
    @comments = @article.comments
    @comment = Comment.new
  end
  
  def edit
    @article = Article.find(params[:id])
  end
  
  def update
    @article = Article.find(params[:id])
    
    if @article.update_attributes(params[:article])
      flash[:notice] = "Successfully updated article"
      redirect_to article_path(@article)
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @article = Article.find(params[:id])
    @article.destroy
    flash[:notice] = "Succesfully destroyed article"
    redirect_to(articles_path)
  end
end
