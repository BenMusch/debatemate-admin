require 'test_helper'

class BlockedContentTestTest < ActionDispatch::IntegrationTest
  test "content allowed for non-users" do
    get root_path
    assert_response :success
    assert_template 'application/index'
  end

  test "content blocked for non-users" do
    blocked_content = [users_path, user_path(id: 1),
                       lessons_path, lesson_pre_lesson_surveys_path(lesson_id: 1)]
    blocked_content.each do |path|
      cant_see_page(path)
    end
  end

  test "users can access their own content but are blocked from others'" do
    log_in_as users(:michael)
    puts "-" * 50
    id = users(:michael).id
    puts "HERE"
    puts id
    puts user_path(id: id)
    get user_path(id: id)
    follow_redirect!
    assert_template 'users/show'
    get lesson_pre_lesson_surveys_path(lesson_id: 1, id: id)
    assert_response :success
    get lesson_path(id: id)
    assert_response :success
    log_in_as users(:john)
    blocked_content = [users_path(id: id),
                       lesson_pre_lesson_surveys_path(lesson_id: 1, id: 1),
                       lesson_path(id: id)]
    blocked_content.each do |path|
      cant_see_page(path)
    end
  end
end
