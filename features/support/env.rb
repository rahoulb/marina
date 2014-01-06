ENV['RAILS_ENV'] = 'test'
require './config/environment'
require 'minitest/spec'
require 'capybara/poltergeist'
require 'database_cleaner'
DatabaseCleaner.strategy = :truncation

Spinach.hooks.before_scenario do 
  `rm #{Rails.root}/tmp/cache/action_mailer_cache_deliveries.cache` if File.exist? "#{Rails.root}/tmp/cache/action_mailer_cache_deliveries.cache"
  DatabaseCleaner.clean
end

Spinach.config.save_and_open_page_on_failure = false

#::Capybara.default_driver = :poltergeist
::Capybara.default_driver = :selenium
