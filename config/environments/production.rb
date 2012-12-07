# Settings specified here will take precedence over those in config/environment.rb

# The production environment is meant for finished, "live" apps.
# Code is not reloaded between requests
config.cache_classes = true

# Full error reports are disabled and caching is turned on
config.action_controller.consider_all_requests_local = false
config.action_controller.perform_caching             = true
config.action_view.cache_template_loading            = true

# config.action_mailer.default_url_options = { :host => 'bgm.sourcepad.com' }
config.action_mailer.default_url_options = { :host => 'www.connectingsexes.com' }
# ::HOST = 'bgm.sourcepad.com'
# ::HOST = 'www.connectingsexes.com'

config.action_mailer.raise_delivery_errors = false
# config.action_mailer.delivery_method = :sendmail
config.action_mailer.delivery_method = :smtp

config.action_mailer.smtp_settings = {
  :user_name => 'jacobconiglio@gmail.com',
  :password => '8ce820a0-51f4-40e0-bee5-78be246e6b8d',
  :port => 2525,
  :address => 'smtp.elasticemail.com',
  :enable_starttls_auto => true,
  :authentication => :login
}
