require 'sidekiq/testing/inline'
Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports and disable caching.
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false
  if Rails.root.join('tmp/caching-dev.txt').exist?
    config.action_controller.perform_caching = true

    config.cache_store = :memory_store
    config.public_file_server.headers = {
        'Cache-Control' => 'public, max-age=172800'
    }
  else
    config.action_controller.perform_caching = false

    config.cache_store = :null_store
  end

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations.
  config.active_record.migration_error = :page_load

  Rails.application.routes.default_url_options = {
      host: '192.168.50.56',
      port: 3000
  }

  # config salt
  config.hashids.salt = 'Elfec2015'
  config.ids_length = 6

  # config fcm api key
  config.fcm_api_key = 'AIzaSyCONvIW4g6sW7ycY4OrrMDc6-zvd7OweyQ'

  config.use_proxy = true
  config.proxy_addr = 'proxy'
  config.proxy_port = 8080

  #config host
  config.domain = 'http://192.168.50.56:3000'

end
