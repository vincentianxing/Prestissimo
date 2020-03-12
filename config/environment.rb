# Load the rails application
require_relative 'application'

# Patches a mysql error where primary keys default to NULL
require File.expand_path('../initializers/abstract_mysql2_adapter.rb', __FILE__)

# Initialize the rails application
Rails.application.initialize!

ENV[ 'RAILS_ENV' ] ||= 'production'
