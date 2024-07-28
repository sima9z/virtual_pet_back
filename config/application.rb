require_relative "boot"

require "rails/all"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "action_cable/engine"
# require "sprockets/railtie"
require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

Dotenv::Rails.load

module App
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    # Only loads a smaller set of middleware suitable for API only apps.
    # Middleware like session, flash, cookies can be added back manually.
    # Skip views, helpers and assets when generating a new resource.
    config.api_only = true
    config.time_zone = 'Tokyo'
    config.active_record.default_timezone = :local
    config.i18n.default_locale = :ja
    config.i18n.available_locales = [:en, :ja]

    # セッションミドルウェアの追加
    config.middleware.use ActionDispatch::Cookies
    config.middleware.use ActionDispatch::Session::CacheStore, {
      expire_after: 30.minutes,
      key: "_#{Rails.application.class.module_parent_name.downcase}_session",
      secure: Rails.env.production?
    }

    config.cache_store = :redis_cache_store, {
      url: ENV['REDIS_URL'],
      namespace: 'cache'
    }

    config.hosts << "back-patient-lake-2960.fly.dev"
    config.hosts << "virtual-pet-front.vercel.app"
    
    config.action_controller.forgery_protection_origin_check = false

    config.after_initialize do
      Rails.logger.debug "Redis URL from ENV: #{ENV['REDIS_URL']}"
      Rails.logger.debug "Redis URL: #{Rails.application.config_for(:redis)[:url]}"
    end

  end
end
