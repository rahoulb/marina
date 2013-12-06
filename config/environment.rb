# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
Marina::Application.initialize!

Jbuilder.key_format camelize: :lower
