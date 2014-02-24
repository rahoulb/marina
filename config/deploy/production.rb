set :stage, :production
set :branch, 'master'
set :app_directory, "/var/www/rails/current"

server 'mpg001.3hv.co.uk', user: 'app', roles: %w{web app db}
