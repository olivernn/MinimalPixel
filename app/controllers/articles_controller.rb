class ArticlesController < ApplicationController
  layout "promotional"
  skip_filter :load_profile
  
  def index
    @articles = Article.active.paginate(:per_page => 5, :page => params[:page])
  end
  
  def show
    @article = Article.find(params[:id])
  end
end
