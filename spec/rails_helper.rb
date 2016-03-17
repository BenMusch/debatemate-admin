ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'spec_helper'
require 'rspec/rails'
require 'database_cleaner'
require 'support/factory_girl'
RSpec.configure do |config|
  config.infer_spec_type_from_file_location!

  config.filter_rails_from_backtrace!

  config.after(:each) do
    DatabaseCleaner[:mongoid].clean
  end

  config.before(:suite) do
    DatabaseCleaner[:mongoid].strategy = :truncation
    DatabaseCleaner[:mongoid].clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner[:mongoid].start
  end

end
