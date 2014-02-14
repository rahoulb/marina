set :stage, :production
set :branch, 'production'

server 'mpg001.3hv.co.uk', user: 'app', roles: %w{web app db}
