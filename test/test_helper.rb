ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Returns true if a test user is logged_in
  def is_logged_in?
    !session[:user_id].nil?
  end

  # Logs in as a test user
  def log_in_as(user, options = {})
    password    = options[:password]    || 'password'
    remember_me = options[:remember_me] || '1'
    if integration_test?
      post login_path, session: { email: user.email,
                                  password: password,
                                  remember_me: remember_me }
    else
      session[:user_id] = user.id
    end
  end

  # Tests that a page can't be seen by the current user
  def cant_see_page(page, options = {})
    get page
    assert_redirected_to root_path
    follow_redirect!
    assert_not flash.empty?
  end

  private

    # Returns true inside an integartion test
    def integration_test?
      defined?(post_via_redirect)
    end
end
