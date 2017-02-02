require_relative 'boot'

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "action_controller/railtie"
# require "action_mailer/railtie"
require "action_view/railtie"
# require "action_cable/engine"
# require "sprockets/railtie"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module SGAMElfecWeb
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de
    # don't generate RSpec tests for views and helpers
    # ActiveModel::Serializer.config.adapter = :json_api
    config.api_only = true
    config.autoload_paths << Rails.root.join('lib')
    config.eager_load_paths << Rails.root.join('lib')
    config.autoload_paths << Rails.root.join('app/messengers')
    config.eager_load_paths << Rails.root.join('app/messengers')
    config.autoload_paths << Rails.root.join('app/messengers/fcm')
    config.eager_load_paths << Rails.root.join('app/messengers/fcm')
    I18n.available_locales = [:en, :es]
    config.encoding = "utf-8"
    config.time_zone = 'La Paz' # set default time zone to "La Paz" (UTC -4)
    config.i18n.default_locale = :es # set default locale to Spanish

    config.generators do |g|
      g.test_framework :rspec, fixture: true
      g.fixture_replacement :factory_girl, dir: 'spec/factories'
      g.view_specs false
      g.helper_specs false
      g.stylesheets = false
      g.javascripts = false
      g.helper = false
    end

    config.hashids = ActiveSupport::OrderedOptions.new
    config.middleware.use Rack::ContentLength
  end
end
