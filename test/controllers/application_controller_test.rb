require 'test_helper'

class ApplicationControllerTest < ActionController::TestCase
  def setup
    @admin = users(:ben)
    @user = users(:michael)
  end

  test "should get index when not logged in" do
    get :index
    assert_response :success
    assert_not is_logged_in?
    assert_template 'application/index'
  end

  test "should redirect to admin_home_page when logged in as admin" do
    log_in_as @admin
    get :index
    assert_template 'application/admin_home_page'
  end

  test "should redirect to users_home_page when logged in as a normal user" do
    log_in_as @user
    get :index
    assert_template 'application/user_home_page'
  end
end
