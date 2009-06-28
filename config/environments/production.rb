# Settings specified here will take precedence over those in config/environment.rb

# The production environment is meant for finished, "live" apps.
# Code is not reloaded between requests
config.cache_classes = true

# Enable threaded mode
# config.threadsafe!

# Use a different logger for distributed setups
# config.logger = SyslogLogger.new

# Full error reports are disabled and caching is turned on
config.action_controller.consider_all_requests_local = false
config.action_controller.perform_caching             = true

# Allow the login session to be used from any subdomain
config.action_controller.session[:domain] = '.minimalpixel.net'

# Use a different cache store in production
# config.cache_store = :mem_cache_store

# Enable serving of images, stylesheets, and javascripts from an asset server
# config.action_controller.asset_host                  = "http://assets.example.com"

# Disable delivery errors, bad email addresses will be ignored
# config.action_mailer.raise_delivery_errors = false

# Restful Authentication
REST_AUTH_SITE_KEY = '1f4b92d1eb016f4c5bf6a68ddaff287f71ce10d1620866a4fc82688e63a1a2492c2323de1c6e21b3a20e6be5ad41a7d71b1900b1461d9dbb0fc92b9db586845d'
REST_AUTH_DIGEST_STRETCHES = 10

# setting up the email details to use google apps
config.action_mailer.delivery_method = :smtp
require "smtp_tls"

ActionMailer::Base.smtp_settings = {:address => "smtp.gmail.com",
:port => 587,
:authentication => :plain,
:user_name => "notifications@minimalpixel.net",
:password => 'begflas555'}

config.after_initialize do
  # Setting up Workling to talk to the Starling message server
  Workling::Remote.dispatcher = Workling::Remote::Runners::StarlingRunner.new
end