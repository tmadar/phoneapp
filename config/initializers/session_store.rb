# Be sure to restart your server when you modify this file.

Phoneapp::Application.config.session_store :redis_store, :redis_server => 'redis://127.0.0.1:6379/0/phoneapp:session', :expire_after => 86400

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rails generate session_migration")
# Phoneapp::Application.config.session_store :active_record_store
