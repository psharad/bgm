set :application, "cs"

set :keep_releases, 5
set :scm, :git
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

set :repository,  "git@github.com:psharad/bgm.git"
set :branch, "master"
# set :repository_cache, "git_cache"
# set :deploy_via, :remote_cache
set :ssh_options, { :forward_agent => true }

role :web, "ec2-50-19-165-45.compute-1.amazonaws.com"                          # Your HTTP server, Apache/etc
role :app, "ec2-50-19-165-45.compute-1.amazonaws.com"                          # This may be the same as your `Web` server
role :db,  "ec2-50-19-165-45.compute-1.amazonaws.com", :primary => true # This is where Rails migrations will run
# role :db,  "your slave db-server here"

set :deploy_to, "/var/rails/#{application}"

set :user, "cs"
set :use_sudo, false

set :branch do
 default_tag = `git tag`.split("\n")

 tag = Capistrano::CLI.ui.ask "Tag to deploy (make sure to push the tag first): [#{default_tag}] "
 tag = default_tag if tag.empty?
 tag
end

namespace :deploy do
 desc "Symlink shared configs and folders on each release."
 task :symlink_shared do
   run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
   run "ln -nfs #{shared_path}/uploads #{release_path}/public/uploads"
 end
 
 desc "Tell Passenger to restart the app."
 task :restart do
   run "touch #{current_path}/tmp/restart.txt"
 end
 
 desc "Stop background tasks."
 task :stop do
 end

 desc "Start background tasks."
 task :start do
 end
 
 desc "Update the crontab file"
 task :update_crontab, :roles => :db do
   run "cd #{release_path} && whenever --update-crontab #{application}"
 end
 
end

before 'deploy:update_code', 'deploy:stop'
after 'deploy:update_code', 'deploy:symlink_shared'
after 'deploy:symlink_shared', 'deploy:start'
# after 'deploy:start', 'deploy:restart'
