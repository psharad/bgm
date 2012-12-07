# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_bgm_session',
  :secret      => '84a2589f11fc578a701f2eb9f822c418dcb2189f88a125d1412d7228a81d3b078c6a5219121bb5e98a3e67efed5efcc930ff37b27641fbdffffa5a0b10480333'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
