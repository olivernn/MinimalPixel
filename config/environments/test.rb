# Settings specified here will take precedence over those in config/environment.rb

# The test environment is used exclusively to run your application's
# test suite.  You never need to work with it otherwise.  Remember that
# your test database is "scratch space" for the test suite and is wiped
# and recreated between test runs.  Don't rely on the data there!
config.cache_classes = true

# Log error messages when you accidentally call methods on nil.
config.whiny_nils = true

# Show full error reports and disable caching
config.action_controller.consider_all_requests_local = true
config.action_controller.perform_caching             = false

# Disable request forgery protection in test environment
config.action_controller.allow_forgery_protection    = false

# Tell Action Mailer not to deliver emails to the real world.
# The :test delivery method accumulates sent emails in the
# ActionMailer::Base.deliveries array.
config.action_mailer.delivery_method = :test

# Restful Authentication
REST_AUTH_SITE_KEY = '1f4b92d1eb016f4c5bf6a68ddaff287f71ce10d1620866a4fc82688e63a1a2492c2323de1c6e21b3a20e6be5ad41a7d71b1900b1461d9dbb0fc92b9db586845d'
REST_AUTH_DIGEST_STRETCHES = 10

# setting up activemerchant and paypal
config.after_initialize do
  ActiveMerchant::Billing::Base.mode = :test
end

# gems required only for testing environment
config.gem "webrat", :lib => false