require 'test_helper'

class UserTest < ActiveSupport::TestCase

  def setup
    @user = User.new(name:  "Example User",
                     email: "example@user.com",
                     admin: false,
                     password:              "foobar",
                     password_confirmation: "foobar",
                     phone:                 1234567890)
  end

  test "authenticated? returns false for a user with a nil digest" do
    assert_not @user.authenticated?(:remember, '')
  end

  test "name must be present" do
    @user.name = "   "
  end

  test "name must be 6 characters or longer" do
    @user.name = "test"
    assert_not @user.valid?
  end

  test "name cannot be over 50 characters" do
    @user.name = "a" * 51
    assert_not @user.valid?
  end

  test "email cannot be over 255 characters" do
    @user.email = "a" * 255 + "@example.com"
    assert_not @user.valid?
  end

  test "email must be present" do
    @user.email = "    "
    assert_not @user.valid?
  end

  test "email must be valid" do
    invalid_emails = %w[test@example not_an_email]
    invalid_emails.each do |email|
      @user.email = email
      assert_not @user.valid?, email
    end
  end

  test "email must be unique" do
    duplicate = @user.dup
    @user.name = "New Name"
    @user.save
    assert_not duplicate.valid?
  end

  test "name must be unique" do
    duplicate = @user.dup
    @user.email = "test@email.com"
    @user.save
    assert_not duplicate.valid?
  end

  test "admins must have an @debatemate.com email" do
    @user.admin = true
    assert_not @user.valid?
    @user.email = "test@debatemate.com"
    assert @user.valid?
  end

  test "passwords must be present" do
    @user.password = @user.password_confirmation = "       "
    assert_not @user.valid?
  end

  test "passwords must be at least 6 characters" do
    @user.password = @user.password_confirmation = "a" * 5
    assert_not @user.valid?
  end

  test "phone must be present" do
    @user.phone = nil
    assert_not @user.valid?
  end

  test "phone must be the right length" do
    @user.phone = 111111111
    assert_not @user.valid?
    @user.phone = 11111111111
    assert_not @user.valid?
  end

  test "should be valid" do
    assert @user.valid?
  end
end
