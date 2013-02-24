set :rails_env, ENV["RAILS_ENV"] || "production"
set :application, "redmine-nuvo"
set :user, "ubuntu"
set :use_sudo, false
set :deploy_to, "/home/#{user}/#{application}"
set :scm, :git
set :branch, "master"
set :repository, "git@github.com:joongimin/redmine-nuvo.git"
set :deploy_via, :remote_cache
set :normalize_asset_timestamps, false
set :maintenance_template_path, File.expand_path("../recipes/templates/maintenance.html.erb", __FILE__)

default_run_options[:pty] = true
ssh_options[:forward_agent] = true

set :root_url, "redmine.xnuvo.com"
set :mysql_database, "redmine"
set :mysql_host, "localhost"
server "redmine.xnuvo.com", :app, :web, :db, :primary => true

require "bundler/capistrano"

load "config/recipes/base"
load "config/recipes/git"
load "config/recipes/nginx"
load "config/recipes/unicorn"
load "config/recipes/rbenv"
load "config/recipes/mysql"

after "deploy:update_code", "deploy:migrate"
after "deploy", "deploy:cleanup" # keep only the last 5 releases

task :copy_manifest do
  run "cp #{shared_path}/assets/#{rails_env}/manifest.yml #{shared_path}/assets/"
end