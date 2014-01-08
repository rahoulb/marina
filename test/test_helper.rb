ENV["RAILS_ENV"] = "test"
require File.expand_path("../../config/environment", __FILE__)
require "rails/test_help"
require "minitest/rails"
require "minitest/pride"
require_relative '../features/support/blueprints'

class ActiveSupport::TestCase

  def login_as member
    post "/api/sessions", username: member.username, password: member.password, format: 'json'
  end
end
