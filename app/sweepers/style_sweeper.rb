class StyleSweeper < ActionController::Caching::Sweeper
  observe Style
  
  def after_update(style)
    expire_style_cache(style)
  end
  
  # this will never get triggered
  def after_create(style)
    expire_style_cache(style)
  end
  
  # this will never get triggered 
  def after_destroy(style)
    expire_style_cache(style)
  end
  
  private
  
  def expire_style_cache(style)
    expire_fragment :controller => :styles, :action => :index, :format => :js
    expire_fragment :controller => :styles, :action => :index, :format => :css
  end
end