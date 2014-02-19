raw_config = YAML.load File.open("#{Rails.root}/config/application.yml")
config = raw_config[Rails.env]

config.each do | key, value |
  Marina::Application.config.send :"#{key}=", value
end

