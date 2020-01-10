# Load the rails application
require File.expand_path('../application', __FILE__)

# Patches a mysql error where primary keys default to NULL
require File.expand_path('../initializers/abstract_mysql2_adapter.rb', __FILE__)

# Initialize the rails application
Prestissimo::Application.initialize!

ENV[ 'RAILS_ENV' ] ||= 'production'
