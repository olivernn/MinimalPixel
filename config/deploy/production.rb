#############################################################
#	Application
#############################################################

set :application, "minimalpixel.net"
set :deploy_to, "/home/admin/public_html/#{application}"

#############################################################
#	Settings
#############################################################

default_run_options[:pty] = true
ssh_options[:forward_agent] = true
ssh_options[:keys] = %w(~/.ssh/saturn)
ssh_options[:port] = 40000
set :use_sudo, true
set :scm_verbose, true
set :rails_env, "production"
set :starling_port, 15151

#############################################################
#	Servers
#############################################################

set :user, "admin"
set :domain, "www.minimalpixel.net"
server domain, :app, :web
role :db, domain, :primary => true

#############################################################
#	Git
#############################################################

set :scm, :git
set :branch, 'master'
set :repository, "git@github.com:olivernn/MinimalPixel.git"
set :deploy_via, :copy
set :runner, user
set :use_sudo, true

#############################################################
#	Passenger
#############################################################

namespace :deploy do
  desc "Create the database yaml file"
  task :after_update_code do
    db_config = <<-EOF
    production:    
      adapter: mysql
      encoding: utf8
      username: rails
      password: computer
      database: minimalpixel_production
      host: localhost
    EOF
    
    put db_config, "#{release_path}/config/database.yml"
  end
  
  # Restart passenger on deploy
  desc "Restarting mod_rails with restart.txt"
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{current_path}/tmp/restart.txt"
  end
end

namespace :symlink do
  desc "Create symlink to shared folder for sources"
  task :sources do
    run "ln -nfs #{shared_path}/sources #{release_path}/public/system/sources"
  end

  desc "Create symlink to shared folder for fonts"
  task :fonts do
    run "ln -nfs #{shared_path}/fonts #{release_path}/public/fonts"
  end
end

#############################################################
#	Starling & Workling
#############################################################

namespace :workling do
  desc "Restart Workling"
  task :restart do
    run "#{deploy_to}/current/script/workling_client stop"
    run "RAILS_ENV=production #{deploy_to}/current/script/workling_client start"
  end
  
  desc "Start Workling"
  task :start do
    run "RAILS_ENV=production #{deploy_to}/current/script/workling_client start"
  end
  
  desc "Stop Workling"
  task :stop do
    run "#{deploy_to}/current/script/workling_client stop"
  end
end

namespace :starling do
  desc "Start Starling"
  task :start do
    run "starling -d -q #{shared_path}/log/ -P #{shared_path}/pids/starling.pid -p #{starling_port}"
  end
end

#############################################################
#	callbacks
#############################################################

after "deploy:restart", "deploy:cleanup", "workling:restart"
after "deploy:symlink", "symlink:sources", "symlink:fonts"