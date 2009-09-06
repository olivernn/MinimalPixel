class SitemapController < ApplicationController
  # responds to a GET /sitemap.xml

  def sitemap
    @users = User.active
    @articles = Article.active
    
    respond_to do |format|
      format.xml # { render :xml => [@pages, @projects], :layout => false }
    end
  end
end