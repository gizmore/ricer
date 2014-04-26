Ricer::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb.
  
  # Initial seed for random generator (non crypto)
  config.rice_seeds = 3133735
  
  # Set to true for less debug output
  config.chopsticks = false

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports and disable caching.
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = true

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations
  config.active_record.migration_error = :page_load

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = false
  
  # Mail SMTP settings  
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
    :address => 'ricer.gizmore.org',
    :port => 587,
    :domain => 'ricer.gizmore.org',
    :authentication => :login,
    :user_name => 'ricer@ricer.gizmore.org',
    :password => 'therice',
    :openssl_verify_mode => OpenSSL::SSL::VERIFY_NONE, 
  }
   # Exception notifier  
  config.middleware.use ExceptionNotifier,
    :email_prefix => "[RicerDev] ",
    :sender_address => %{"RicerBot" <ricer@ricer.gizmore.org>},
    :exception_recipients => %w{gizmore@gizmore.org}

end
