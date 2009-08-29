ActionController::Routing::Routes.draw do |map|

  map.resources :pages, :collection => {:validate => :get}
  map.resources :contact, :collection => {:validate => :get}
  
  map.complete_account '/complete', :controller => 'users', :action => 'complete'
  map.upgrade_account '/upgrade', :controller => 'accounts', :action => 'upgrade'
  
  # Restful Authentication Rewrites
  map.logout '/logout', :controller => 'sessions', :action => 'destroy'
  map.login '/login', :controller => 'sessions', :action => 'new'
  map.register '/register', :controller => 'users', :action => 'create'
  map.signup '/signup', :controller => 'plans', :action => 'index'
  map.activate '/activate/:activation_code', :controller => 'users', :action => 'activate', :activation_code => nil
  map.forgot_password '/forgot_password', :controller => 'passwords', :action => 'new'
  map.change_password '/change_password/:reset_code', :controller => 'passwords', :action => 'reset'
  # map.open_id_complete '/opensession', :controller => "sessions", :action => "create", :requirements => { :method => :get }
  # map.open_id_create '/opencreate', :controller => "users", :action => "create", :requirements => { :method => :get }
  
  # Added for the sitemap generator
  map.sitemap 'sitemap.xml', :controller => 'sitemap', :action => 'sitemap'
  
  map.resources :plans do |plan|
    plan.resources :users, :collection => {:validate => :get}
  end
  
  map.resources :projects do |project|
    project.resources :items, :collection => {:sort => :put}
    project.resources :images
    project.resources :videos
  end
  
  map.resources :draft_projects, :member => {:publish => :put}, :collection => {:validate => :get}
  map.resources :passwords
  map.resource :session
  map.resources :styles
  map.resources :profiles
  map.resources :accounts
  map.resources :fonts
  map.resources :subscriptions
  map.resources :themes
  
  # promotional routes here
  map.resources :articles do |article|
    article.resources :comments
  end
  
  map.link_user_accounts '/facebook/link_user_accounts', :controller => 'facebook', :action => 'link_user_accounts'
  map.resources :questions
  map.resources :feedback, :collection => {:validate => :get}
  map.resources :draft_articles, :member => {:publish => :put}
  
  # mapping the blog root
  map.blog_root '', :controller => 'articles', :action => 'index', :subdomain => 'blog', :conditions => { :subdomain => /blog/ }
  
  # map subdomains to the projects controller
  map.projects_root '', :controller => 'projects', :action => 'index', :conditions => { :subdomain => /www+|.+/}
  
  # static page re-writes
  map.root :controller => 'static', :action => 'welcome'
  map.terms '/terms', :controller => 'static', :action => 'terms'
  
  # Install the default routes as the lowest priority.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
