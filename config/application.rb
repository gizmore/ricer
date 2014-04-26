require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)

module Ricer
  class Application < Rails::Application
    
    config.autoload_paths += %W["#{config.root}/app/validators/"]
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    config.time_zone = 'Berlin'
    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    config.i18n.default_locale = :en
    config.i18n.fallbacks = [:en]
    I18n.enforce_available_locales = false
    config.i18n.enforce_available_locales = false
    
    # TODO: Disable cache! (below is not working) 
##### config.middleware.delete "ActiveRecord::QueryCache"

    config.ricer_version = '0.92a'
    config.ricer_version_date = Time.new(2014, 3, 19, 1, 59, 26)
    
  end
end
