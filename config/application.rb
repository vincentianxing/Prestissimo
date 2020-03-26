require_relative "boot"
require "rails"
# Pick the frameworks you want:
require "csv"
require "active_record/railtie"
require "active_storage/engine"
require "action_controller/railtie"
require "action_mailer/railtie"
require "digest/md5"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Prestissimo
  class Application < Rails::Application

    # Initialize configuration defaults for Rails 6.0
    config.load_defaults "6.0"

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

    # Embed purpose and expiry metadata inside signed and encrypted
    # cookies for increased security.
    #
    # This option is not backwards compatible with earlier Rails versions.
    # It's best enabled when your entire app is migrated and stable on 6.0.
    # Rails.application.config.action_dispatch.use_cookies_with_metadata = true

    # When assigning to a collection of attachments declared via `has_many_attached`, replace existing
    # attachments instead of appending. Use #attach to add new attachments without replacing existing ones.
    Rails.application.config.active_storage.replace_on_assign_to_many = true

    # New in Rails 6
    # Opimizes load paths by not including user define paths (I think)
    config.add_autoload_paths_to_load_path = false

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
    config.assets.enabled = false

    # Version of your assets, change this if you want to expire all your assets
    config.assets.version = "1.0"

    # set default host for mailer urls
    config.action_mailer.delivery_method = :sendmail

    # allows for custom error pages
    # sets own app as responsible for showing error pages
    config.exceptions_app = self.routes

    # Allows transition from Marshal based cookies to JSON based ones
    config.action_dispatch.cookies_serializer = :hybrid
  end
end
