ExceptionNotification::Notifier.configure_exception_notifier do |config|
  config[:app_name]                 = "[Connecting Sexes]"
  config[:sender_address]           = "super.exception.notifier@connectingsexes.com"
  config[:exception_recipients]     = %w(victorm@sourcepad.com) # You need to set at least one recipient if you want to get the notifications
  # In a local environment only use this gem to render, never email
  #defaults to false - meaning by default it sends email.  Setting true will cause it to only render the error pages, and NOT email.
  config[:skip_local_notification]  = false
  # Error Notification will be sent if the HTTP response code for the error matches one of the following error codes
  # config[:notify_error_codes]       = %W( 405 500 503 )
  # Error Notification will be sent if the error class matches one of the following error classes
  # config[:notify_error_classes]     = %W( )
  # What should we do for errors not listed?
  # config[:notify_other_errors]      = true
  # If you set this SEN will attempt to use git blame to discover the person who made the last change to the problem code
  # config[:git_repo_path]            = nil # ssh://git@blah.example.com/repo/webapp.git
  config[:subject_prepend]          = "[#{(defined?(Rails) ? Rails.env : RAILS_ENV).capitalize} ERROR] "
end
