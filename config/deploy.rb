set :stages, %w(staging production)
set :default_stage, "production"
require File.expand_path("#{File.dirname(__FILE__)}/../vendor/gems/capistrano-ext-1.2.1/lib/capistrano/ext/multistage")


namespace :db do
  desc 'Dumps the production database to db/production_data.sql on the remote server'
  task :remote_db_dump, :roles => :db, :only => { :primary => true } do
    run "cd #{deploy_to}/#{current_dir} && " +
      "rake RAILS_ENV=#{rails_env} db:database_dump --trace" 
  end

  desc 'Downloads db/production_data.sql from the remote production environment to your local machine'
  task :remote_db_download, :roles => :db, :only => { :primary => true } do  
    execute_on_servers(options) do |servers|
      self.sessions[servers.first].sftp.connect do |tsftp|
        tsftp.download!("#{deploy_to}/#{current_dir}/db/production_data.sql", "db/production_data.sql")
      end
    end
  end

  desc 'Cleans up data dump file'
  task :remote_db_cleanup, :roles => :db, :only => { :primary => true } do
    execute_on_servers(options) do |servers|
      self.sessions[servers.first].sftp.connect do |tsftp|
        tsftp.remove! "#{deploy_to}/#{current_dir}/db/production_data.sql" 
      end
    end
  end 

  desc 'Dumps, downloads and then cleans up the production data dump'
  task :remote_db_runner do
    remote_db_dump
    remote_db_download
    remote_db_cleanup
  end
end

namespace :backup do
  task :images do
    filename = "#{Time.now.strftime("%Y%m%d")}_production_images.tgz"
    server_filename = "/home/admin/tmp/#{filename}"
    local_filename = "/Users/Oliver/Documents/rails_projects/iportfolio/backups/#{filename}"
    
    on_rollback { run "rm #{server_filename}"}
    
    run "tar -czvf #{server_filename} /home/admin/public_html/minimalpixel.net/shared/system/"
    
    get server_filename, local_filename
    sudo "rm #{server_filename}"
  end
  
  task :fonts do
    filename = "#{Time.now.strftime("%Y%m%d")}_production_fonts.tgz"
    server_filename = "/home/admin/tmp/#{filename}"
    local_filename = "/Users/Oliver/Documents/rails_projects/iportfolio/backups/#{filename}"
    
    on_rollback { run "rm #{server_filename}"}
    
    run "tar -czvf #{server_filename} /home/admin/public_html/minimalpixel.net/shared/fonts/"
    
    get server_filename, local_filename
    sudo "rm #{server_filename}"
  end
end