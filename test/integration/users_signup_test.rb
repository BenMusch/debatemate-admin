require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest

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

  test "successful signup" do
    get signup_path
    assert_difference 'User.count', 1 do
      post_via_redirect users_path, user: { name: "Test Person",
                                            email: "test@example.com",
                                            password: "foobar",
                                            password_confirmation: "foobar",
                                            admin: "0" }
    end
    assert_template 'users/show'
  end
end
