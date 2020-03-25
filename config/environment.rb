# Load the rails application
require_relative 'application'

# Initialize the rails application
Rails.application.initialize!

ENV[ 'RAILS_ENV' ] ||= 'production'
