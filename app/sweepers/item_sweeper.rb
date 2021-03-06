class ItemSweeper < ActionController::Caching::Sweeper
  observe Item
  
  def after_update(item)
    expire_item_cache(item)
  end
  
  def after_create(item)
    expire_item_cache(item)
  end
  
  def after_destroy(item)
    expire_item_cache(item)
  end
  
  private
  
  def expire_item_cache(item)
    # expire the index page action cache
    # expire_fragment(%r{projects.cache})
    expire_fragment(%r{#{item.project.user.subdomain}/projects/index*})
    
    # expire all the formats for item controllers show action, the expire_action method
    # seems to ignore the format part of the action cache
    # expire_action :controller => :item, :action => :show, :id => item 
    # expire_fragment(%r{/items/show/#{item.to_param}})
    # expire_action :controller => :items, :action => :show, :id => item, :format => :js
    # expire_action :controller => :items, :action => :show, :id => item
    expire_fragment(%r{#{item.project.user.subdomain}/items/show/#{item.to_param}*})
    
    # expire the projects show action, need to do this explicitly because of the 
    # name in filename of the cache which is not available to the item
    # expire_action :controller => :projects, :action => :show, :id => item.project_id
    # expire_fragment(%r{/projects/#{item.project_id}-})
    expire_fragment(%r{#{item.project.user.subdomain}/projects/show/#{item.project.to_param}*})
    
    # check to see if this item belongs to a draft_project if so then we want to expire the draft project index page
    if item.project.draft?
      expire_fragment(%r{#{item.project.user.subdomain}/draft_projects/index*})
    end
    # we can rely on the built in expire_action methods for the index pages
    expire_action :controller => :projects, :action => :index
    expire_action :controller => :draft_projects, :action => :index
  end
end