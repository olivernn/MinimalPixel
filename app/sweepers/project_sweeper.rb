class ProjectSweeper < ActionController::Caching::Sweeper
  observe Project
  
  def after_update(project)
    expire_project_cache(project)
  end
  
  def after_create(project)
    expire_project_cache(project)
  end
  
  def after_destroy(project)
    expire_project_cache(project)
  end
  
  private
  
  def expire_project_cache(project)
    # expire the index page action cache
    # expire_fragment(%r{projects.cache}) #-- not sure what this will be yet
    
    expire_action :controller => :projects, :action => :index
    expire_action :controller => :projects, :action => :show, :id => project 
    expire_action :controller => :draft_projects, :action => :index
  end
end