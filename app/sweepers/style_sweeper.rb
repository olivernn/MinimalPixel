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
    # need to also sweep the item js show action as the item title doesn't pick-up the new styles
    # expire_fragment(%r{/items/})
    # expire_fragment(%r{#{style.user.subdomain}/items/show/*})
    
    # expire_fragment(%r{styles/#{style.id}.*})
    expire_page :controller => :styles, :action => :show, :id => style, :format => :js
    expire_page :controller => :styles, :action => :show, :id => style, :format => :css
    
    # expire all fragments
    expire_fragment(%r{#{style.user.subdomain}/*})
  end
end