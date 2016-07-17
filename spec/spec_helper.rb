ENV["RAILS_ENV"] ||= "test"
require "rails/mongoid"
require "capybara/rspec"
require "database_cleaner"
require "capybara/email/rspec"

RSpec.configure do |config|

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.include Capybara::DSL
  config.include Capybara::Email::DSL

end
