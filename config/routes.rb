ActionController::Routing::Routes.draw do |map|
  map.resources :themes
  
  map.complete_account '/complete', :controller => 'users', :action => 'complete'
  
  map.resources :subscriptions
  
  # Restful Authentication Rewrites
  map.logout '/logout', :controller => 'sessions', :action => 'destroy'
  map.login '/login', :controller => 'sessions', :action => 'new'
  map.register '/register', :controller => 'users', :action => 'create'
  map.signup '/signup', :controller => 'users', :action => 'new'
  map.activate '/activate/:activation_code', :controller => 'users', :action => 'activate', :activation_code => nil
  map.forgot_password '/forgot_password', :controller => 'passwords', :action => 'new'
  map.change_password '/change_password/:reset_code', :controller => 'passwords', :action => 'reset'
  map.open_id_complete '/opensession', :controller => "sessions", :action => "create", :requirements => { :method => :get }
  map.open_id_create '/opencreate', :controller => "users", :action => "create", :requirements => { :method => :get }
  
  map.resources :plans do |plan|
    plan.resources :users
  end
  
  map.resources :projects do |project|
    project.resources :items, :collection => {:sort => :put}
    project.resources :images
  end
  
  map.resources :draft_projects, :member => {:publish => :put}
  map.resources :passwords
  map.resource :session
  map.resources :styles
  map.resources :profiles
  map.resources :accounts
  
  # map subdomains to the projects controller
  map.projects_root '', :controller => 'projects', :action => 'index', :conditions => { :subdomain => /.+/}
  
  # Home Page
  map.root :controller => 'sessions', :action => 'new'

  # Install the default routes as the lowest priority.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
