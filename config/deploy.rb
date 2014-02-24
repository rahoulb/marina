set :application, 'marina'
set :repo_url, 'git@github.com:rahoulb/marina.git'
set :deploy_to, '/var/www/rails'
set :scm, :git

set :bundle_gemfile, -> { release_path.join('Gemfile') }
set :bundle_dir, -> { shared_path.join('bundle') }
set :bundle_flags, '--deployment --quiet'
set :bundle_without, %w{development test}.join(' ')
set :bundle_binstubs, -> { shared_path.join('bin') }
set :bundle_bins, %w(gem rake ruby)
set :bundle_roles, :all
set :whenever_roles,        ->{ :db }
set :whenever_options,      ->{ {:roles => fetch(:whenever_roles)} }
set :whenever_command,      ->{  }
set :whenever_identifier,   ->{ fetch :application }
set :whenever_environment,  ->{ fetch :rails_env, "production" }
set :whenever_variables,    ->{ "environment=#{fetch :whenever_environment}" }
set :whenever_update_flags, ->{ "--update-crontab #{fetch :whenever_identifier} --set #{fetch :whenever_variables}" }
set :whenever_clear_flags,  ->{ "--clear-crontab #{fetch :whenever_identifier}" }
set :migration_role, :db
set :format, :pretty
set :log_level, :info

set :linked_files, %w{config/database.yml config/application.yml .env}
set :linked_dirs, %w{log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

# set :default_env, { path: "/opt/ruby/bin:$PATH" }
set :keep_releases, 5

namespace :deploy do
  desc 'Initialise upstart'
  task :to_upstart do
    on roles(:web) do
      within fetch(:app_directory) do
        with rails_env: fetch(:rails_env) do
          sudo :bundle, "exec foreman export -t config/upstart -a #{fetch(:application)} -u #{fetch(:user)} -e .env -p 8080 -c web=1,workers=0 upstart /etc/init"
        end
      end
    end
    on roles(:worker) do
      within fetch(:app_directory) do
        with rails_env: fetch(:rails_env) do
          sudo :bundle, "exec foreman export -t config/upstart -a #{fetch(:application)} -u #{fetch(:user)} -e .env -p 8080 -c web=0,workers=4 upstart /etc/init"
        end
      end
    end
  end

  desc 'Start application'
  task :start do
    on roles(:app) do
      sudo :start, fetch(:application)
    end
  end

  desc 'Stop application'
  task :stop do
    on roles(:app) do
      sudo :stop, fetch(:application), raise_on_non_zero_exit: false
      within fetch(:app_directory) do
        pids = capture :ls, "tmp/pids/*.pid", raise_on_non_zero_exit: false
        pids.to_s.split(' ').each do | pidfile |
          pid = capture(:cat, pidfile, raise_on_non_zero_exit: false).to_s.strip
          execute :kill, pid, raise_on_non_zero_exit: false unless pid == ''
        end
      end
    end
  end

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      sudo :stop, fetch(:application), raise_on_non_zero_exit: false
      within fetch(:app_directory) do
        pids = capture :ls, "tmp/pids/*.pid", raise_on_non_zero_exit: false
        pids.to_s.split(' ').each do | pidfile |
          pid = capture(:cat, pidfile, raise_on_non_zero_exit: false).to_s.strip
          execute :kill, pid, raise_on_non_zero_exit: false unless pid == ''
        end
      end
      sudo :start, fetch(:application)
    end
  end

  before "deploy:finishing", "deploy:restart"
  before "deploy:restart", "deploy:to_upstart"
  after "deploy:finishing", 'deploy:cleanup'
end
