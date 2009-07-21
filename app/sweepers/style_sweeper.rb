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
    # expire_fragment :controller => :styles, :action => :index, :format => :js
    # expire_fragment :controller => :styles, :action => :index, :format => :css
    
    # need to also sweep the item js show action as the item title doesn't pick-up the new styles
    # expire_fragment(%r{/items/})
    # expire_fragment(%r{#{style.user.subdomain}/items/show/*})
    
    # expire all fragments
    expire_fragment(%r{#{style.user.subdomain}/*})
  end
end