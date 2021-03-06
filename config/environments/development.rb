# Settings specified here will take precedence over those in config/environment.rb

# In the development environment your application's code is reloaded on
# every request.  This slows down response time but is perfect for development
# since you don't have to restart the webserver when you make code changes.
config.cache_classes = false

# Log error messages when you accidentally call methods on nil.
config.whiny_nils = true

# Show full error reports and disable caching
config.action_controller.consider_all_requests_local = true
config.action_view.debug_rjs                         = true
config.action_controller.perform_caching             = false

# Don't care if the mailer can't send
config.action_mailer.raise_delivery_errors = false

# Allow the login session to be used from any subdomain
config.action_controller.session[:domain] = '.localhost'

# Setting up multiple asset hosts for javascripts, stylesheets, images and flash
config.action_controller.asset_host = "http://assets%d.localhost:3000"

# including the custom domain middleware
config.middleware.use "CustomDomain", ".localhost"

# Restful Authentication
REST_AUTH_SITE_KEY = '1f4b92d1eb016f4c5bf6a68ddaff287f71ce10d1620866a4fc82688e63a1a2492c2323de1c6e21b3a20e6be5ad41a7d71b1900b1461d9dbb0fc92b9db586845d'
REST_AUTH_DIGEST_STRETCHES = 10
  
# setting up activemerchant and paypal
config.after_initialize do
  ActiveMerchant::Billing::Base.mode = :test
  # Setting up Workling to talk to the Starling message server
  Workling::Remote.dispatcher = Workling::Remote::Runners::StarlingRunner.new
end