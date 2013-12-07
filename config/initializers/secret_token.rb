raw_config = YAML.load File.open("#{Rails.root}/config/application.yml")
config = raw_config[Rails.env]

Marina::Application.config.secret_key_base = config['secret_key_base']
