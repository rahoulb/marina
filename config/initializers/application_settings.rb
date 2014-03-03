# Initializers are loaded in alphabetical order, so application_settings should load first - subsequent initializers can then read the values from Marina::Application.config

raw_config = YAML.load File.open("#{Rails.root}/config/application.yml")
config = raw_config[Rails.env]

config.each do | key, value |
  Marina::Application.config.send :"#{key}=", value
end

