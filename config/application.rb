require_relative 'boot'
require 'rails'
# Pick the frameworks you want:
require "csv"
require "active_record/railtie"
# require "active_storage/railite"
require "action_controller/railtie"
require "action_mailer/railtie"
require "sprockets/railtie"
require 'digest/md5'


# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Prestissimo
  class Application < Rails::Application

    # Initialize configuration defaults for originally generated Rails version.
    # config.load_defaults 5.0

    # Use UTF8Sanitizer (rack-utf8_sanitizer gem)
    # config.middleware.insert 0, Rack::UTF8Sanitizer

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Custom directories with classes and modules you want to be autoloadable.
    # config.autoload_paths += %W(#{config.root}/extras)

    # Only load the plugins named here, in the order given (default is alphabetical).
    # :all can be used as a placeholder for all plugins not explicitly named.
    # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

    # Activate observers that should always be running.
    # config.active_record.observers = :cacher, :garbage_collector, :forum_observer

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Eastern Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # Configure the default encoding used in templates for Ruby 1.9.
    config.encoding = "utf-8"

    # Configure sensitive parameters which will be filtered from the log file.
    config.filter_parameters += [:password]

    # Enable escaping HTML in JSON.
    config.active_support.escape_html_entities_in_json = true

    # Use SQL instead of Active Record's schema dumper when creating the database.
    # This is necessary if your schema can't be completely dumped by the schema dumper,
    # like if you have constraints or database-specific column types
    # config.active_record.schema_format = :sql

    ### Following is depreciated with Rails 4.0 (I think)
    # Enforce whitelist mode for mass assignment.
    # This will create an empty whitelist of attributes available for mass-assignment for all models
    # in your app. As such, your models will need to explicitly whitelist or blacklist accessible
    # parameters by using an attr_accessible or attr_protected declaration.
    # config.active_record.whitelist_attributes = true

    # Enable the asset pipeline
    config.assets.enabled = true

    # Call top level js and css files
    config.assets.precompile += %w( jquery-1.10.2.js )
    config.assets.precompile += %w( print.css )
    config.assets.precompile += %w( print_collapsed.css )
    config.assets.precompile += %w( print_expanded.css )
    config.assets.precompile += %w( jquery-ui-1.10.3.custom.css )

    # Version of your assets, change this if you want to expire all your assets
    config.assets.version = '1.0'

    # set default host for mailer urls
    config.action_mailer.delivery_method = :sendmail

    # allows for custom error pages
    # sets own app as responsible for showing error pages
    config.exceptions_app = self.routes

    # Allows transition from Marshal based cookies to JSON based ones
    config.action_dispatch.cookies_serializer = :hybrid
  end
end
