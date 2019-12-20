require_relative 'boot'

require 'rails/all'

require_relative '../lib/middlewares/basic_auth_middleware.rb'
# require Rails.root.join('lib', 'middlewares', 'basic_auth_middleware.rb')

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module RackBasicAuth
  class Application < Rails::Application

    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    config.middleware.use(::Middlewares::BasicAuthMiddleware)
  end
end
