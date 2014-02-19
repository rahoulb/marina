set :stage, :production
set :branch, 'master'

server 'mpg001.3hv.co.uk', user: 'app', roles: %w{web app db}
