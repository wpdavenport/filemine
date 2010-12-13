load 'deploy' if respond_to?(:namespace)

$:.unshift(File.expand_path('./lib', ENV['rvm_path']))
require 'rvm/capistrano'
set :rvm_ruby_string, 'ruby-1.9.2-p0'
set :rvm_type,        :user

server 'filemine.infoether.com', :app, :web, :db, :primary => true

set :application,           'filemine'
set :scm,                   :git
set :repository,            'git@github.com:wpdavenport/filemine.git'
set :branch,                'origin/master'
set(:deploy_to)             { "/var/www/filemine.infoether.com" }
set :user,                  'filemine'
set :group,                 'filemine'
set :use_sudo,              false
set :shared_children,       %w(log system)

set :cleanup_targets,       %w(config/private log public/system)
set :release_directories,   %w(log tmp)

set(:shared_symlinks) do
  {
    'log'      => 'log',
    'system'   => 'public/system'
  }
end

def run_remote(cmd)
  run "cd #{current_path} && #{cmd}"
end

def run_remote_rake(task)
  run_remote("rake #{task}")
end

def bundle_exec(cmd)
  run_remote("bundle exec #{cmd}")
end

after  'deploy:setup',       'deploy:bundler:install'
before 'deploy:symlink',     'deploy:bundler'

namespace :deploy do

  desc "Deploy the current stage"
  task :default do
    update
    restart
  end

  desc "Set up the current stage for Git-based deployment"
  task :setup, :except => { :no_release => true } do
    setup_command = ["git clone #{repository} #{current_path}"]
    setup_command << shared_children.map { |dir| "mkdir -p #{shared_path}/#{dir} && chmod g+w #{shared_path}/#{dir}" }
    run setup_command.join(' && ')
  end

  desc "Update the current stage to the latest revision"
  task :update_code, :except => { :no_release => true } do
    update_command = ["git fetch origin && git reset --hard #{branch}"]
    update_command << "echo #{branch} > #{current_path}/BRANCH"
    update_command << "git rev-parse --verify HEAD --short > #{current_path}/REVISION"
    run "cd #{current_path} && #{update_command.join(' && ')}"
  end

  desc "Create symlinks to stage-specific configuration files and shared assets"
  task :symlink, :except => { :no_release => true } do
    command = cleanup_targets.map { |target| "rm -fr #{current_path}/#{target}" }
    command += release_directories.map { |directory| "mkdir -p #{directory}" }
    command += shared_symlinks.map { |from, to| "rm -fr #{current_path}/#{to} && ln -sf #{shared_path}/#{from} #{current_path}/#{to}" }
    run "cd #{current_path} && #{command.join(" && ")}"
  end

  namespace :rollback do
    task :default do
      code
    end

    task :code, :except => { :no_release => true } do
      set :branch, 'HEAD^'
      deploy
    end
  end

  namespace :bundler do

    task :default do
      install
    end

    desc "Install the gem bundle for the application"
    task :install, :roles => :app, :except => { :no_release => true } do
      run_remote('bundle install --deployment')
    end

  end
	
  desc "Start the application via Passenger light"
  task :start, :roles => :app, :except => { :no_release => true } do
   run "thin start -d -l log/server.log -P tmp/server.pid -p 9700 -e production"
  end

  desc "Stop Passenger light"
  task :stop, :roles => :app, :except => { :no_release => true } do
   run "thin stop -P tmp/server.pid"
  end

  desc "Restart the application and prestart Passenger"
  task :restart, :roles => :app, :except => { :no_release => true } do
   stop
   start
  end
end