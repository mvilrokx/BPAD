# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_bpad_session',
  :secret      => '0a9326c00ed361e2ff459005e69eceee3919afe48767da5772df9168e4130a5d6e6b61e126d1a6cd8ecd7b12a5f030b91e43d8a9d41bdb432662fcc0cfeee28a'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
