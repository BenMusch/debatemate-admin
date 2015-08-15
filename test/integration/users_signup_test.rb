require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest

  def setup
    ActionMailer::Base.deliveries.clear
  end

  test "invalid signup information" do
    get signup_path
    assert_no_difference 'User.count' do
      post users_path, user: { name: " ",
                               email: "invalid",
                               password: "password",
                               password_confirmation: "anotherpassword",
                               admin: "1" }
    end
    assert_template 'users/new'
  end

  test "successful signup with account activation" do
    get signup_path
    User.all.each { |u| u.delete }
    assert_difference 'User.count', 1 do
      post users_path, user: { name: "Test Person",
                               email: "test@example.com",
                               password: "foobar",
                               password_confirmation: "foobar",
                               admin: "0" }
    end
    assert_equal 1, ActionMailer::Base.deliveries.size
    user = assigns(:user)
    assert_not user.activated?
    # Try to log in before activation.
    log_in_as(user)
    assert_not is_logged_in?
    # Invalid activation token
    get edit_account_activation_path("invalid token")
    assert_not is_logged_in?
    # Valid token, wrong email
    get edit_account_activation_path(user.activation_token, email: 'wrong')
    assert_not is_logged_in?
    # Valid activation token
    get edit_account_activation_path(user.activation_token, email: user.email)
    assert user.reload.activated?
    follow_redirect!
    assert is_logged_in?
  end
end
