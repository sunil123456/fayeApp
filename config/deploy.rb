# config valid for current version and patch releases of Capistrano
lock "~> 3.11.0"

set :application, "fayeApp"
set :repo_url, "git@github.com:sunil123456/fayeApp.git"

set :branch, :master
set :deploy_to, '/home/deploy/fayeApp'
set :pty, true
set :linked_files, %w{config/database.yml config/application.yml}
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system public/uploads}
set :keep_releases, 5
set :rvm_type, :user
set :rvm_ruby_version, '2.2.10' # Edit this if you are using MRI Ruby

set :puma_rackup, -> { File.join(current_path, 'config.ru') }
set :puma_state, "#{shared_path}/tmp/pids/puma.state"
set :puma_pid, "#{shared_path}/tmp/pids/puma.pid"
set :puma_bind, "unix://#{shared_path}/tmp/sockets/puma.sock"    #accept array for multi-bind
set :puma_conf, "#{shared_path}/puma.rb"
set :puma_access_log, "#{shared_path}/log/puma_error.log"
set :puma_error_log, "#{shared_path}/log/puma_access.log"
set :puma_role, :app
set :puma_env, fetch(:rack_env, fetch(:rails_env, 'production'))
set :puma_threads, [0, 8]
set :puma_workers, 0
set :puma_worker_timeout, nil
set :puma_init_active_record, true
set :puma_preload_app, false

set :private_pub_pid, -> { "#{current_path}/tmp/pids/private_pub.pid" }
set :private_pub_socket, -> { "#{current_path}/tmp/sockets/private_pub.sock" }
set :private_pub_rackup, -> { "#{current_path}/private_pub.ru" }

namespace :private_pub do
  desc "Start private_pub server"
  task :start do
    on roles(:app) do
      within release_path do
        with rails_env: fetch(:stage) do
          execute :bundle, "exec thin -e production -d -P #{fetch(:private_pub_pid)} -S #{fetch(:private_pub_socket)} -R #{fetch(:private_pub_rackup)} start"
        end
      end
    end
  end

  desc "Stop private_pub server"
  task :stop do
    on roles(:app) do
      within release_path do
        execute "if [ -f #{fetch(:private_pub_pid)} ] && [ -e /proc/$(cat #{fetch(:private_pub_pid)}) ]; then kill -9 `cat #{fetch(:private_pub_pid)}`; fi"
      end
    end
  end

  desc "Restart private_pub server"
  task :restart do
    on roles(:app) do
      invoke 'private_pub:stop'
      invoke 'private_pub:start'
    end
  end
end

after 'deploy:restart', 'private_pub:restart'
# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
# set :deploy_to, "/var/www/my_app_name"

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# append :linked_files, "config/database.yml"

# Default value for linked_dirs is []
# append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system"

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for local_user is ENV['USER']
# set :local_user, -> { `git config user.name`.chomp }

# Default value for keep_releases is 5
# set :keep_releases, 5

# Uncomment the following to require manually verifying the host key before first deploy.
# set :ssh_options, verify_host_key: :secure
