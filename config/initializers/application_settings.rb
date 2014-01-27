raw_config = YAML.load File.open("#{Rails.root}/config/application.yml")
config = raw_config[Rails.env]

Marina::Application.config.secret_key_base = config['secret_key_base']
Marina::Application.config.auto_approval_code = config['auto_approval_code']
Marina::Application.config.admin_username = config['admin_username']
