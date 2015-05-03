# config valid only for current version of Capistrano

require 'rvm/capistrano'
require "bundler/capistrano"
load 'deploy/assets'
# main details
set :rvm_type, :user
set :application, "PicHub"
set :use_sudo, false
set :keep_releases, 10 # 5 by default
set :scm, :git

$:.unshift(File.expand_path('./lib', ENV['rvm_path']))
# server details
default_run_options[:pty] = true
ssh_options[:forward_agent] = true
task :production do
set :rvm_ruby_string, "2.0.0"
set :location, "52.11.115.219"
role :web, location
role :app, location
role :db, location, :primary => true
set :deploy_to, "/var/www/PicHub"
set :user, "ubuntu"
set :rails_env, :production
# repo details
set :scm_username, "ubuntu"
set :repository, "ssh://ubuntu@#{location}/home/ubuntu/Production/PicHub.git/"
set :branch, "master"
end

after 'deploy:update_code', 'bundler:install'
after 'deploy:update', 'deploy:cleanup'

namespace :deploy do
  task :start, :roles => :app do
    run "touch #{current_path}/tmp/restart.txt"
  end
  desc "Restart Application"
  task :restart, :roles => :app do
    run "touch #{current_path}/tmp/restart.txt"
  end
end

namespace :bundler do
  desc "Install for production"
  task :install, :roles => :app do
    run "cd #{release_path} && bundle install"
  end
end
namespace :db do
  desc "Create #{rails_env} Database"
  task :create do
    puts "\n\n=== Creating the #{rails_env} Database! ===\n\n"
    run "cd #{current_path}; rake db:create RAILS_ENV=#{rails_env}"
  end
  desc "Migrate #{rails_env} Database"
  task :migrate do
    puts "\n\n=== Migrating the #{rails_env} Database! ===\n\n"
    run "cd #{current_path}; rake db:migrate RAILS_ENV=#{rails_env}"
  end
  desc "Resets the #{rails_env} Database"
  task :migrate_reset do
    puts "\n\n=== Resetting the #{rails_env} Database! ===\n\n"
    run "cd #{current_path}; rake db:migrate:reset RAILS_ENV=#{rails_env}"
  end
  desc "Destroys #{rails_env} Database"
  task :drop do
    puts "\n\n=== Destroying the #{rails_env} Database! ===\n\n"
    run "cd #{current_path}; rake db:drop RAILS_ENV=#{rails_env}"
  end
  desc "Populates the #{rails_env} Database"
  task :seed do
    puts "\n\n=== Populating the #{rails_env} Database! ===\n\n"
    run "cd #{current_path}; rake db:seed RAILS_ENV=#{rails_env}"
  end
end
# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call

# Default deploy_to directory is /var/www/my_app_name
# set :deploy_to, '/var/www/my_app_name'

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# set :linked_files, fetch(:linked_files, []).push('config/database.yml')

# Default value for linked_dirs is []
# set :linked_dirs, fetch(:linked_dirs, []).push('bin', 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

#namespace :deploy do

#  after :restart, :clear_cache do
#    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
#    end
#  end

#end
