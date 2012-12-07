# Be sure to restart your server when you modify this file

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.8' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  # config.gem "haml"
  # config.gem "authlogic", :version => '2.1.6'
  # config.gem 'sunspot', :version => '1.2.1'
  # config.gem 'sunspot_rails', :version => '1.2.1'
  # config.gem 'will_paginate', :version => '2.3.15'
  # config.gem "friendly_id", :version => '3.0.1'
  # config.gem "mini_fb", :version => '1.1.3'
  # config.gem "super_exception_notifier", :version => '3.0.13', :lib => "exception_notification"
  # config.gem "acl9", :version => '0.12.0'
  # config.gem "grackle", :version => '0.1.10'
  # config.gem 'dancroak-twitter-search', :source => 'http://gems.github.com', :version => '0.5.8'
  config.time_zone = 'UTC'
end

