require 'test_helper'

class LessonsControllerTest < ActionController::TestCase
  def setup
    @user1    = users(:michael).id
    @user2    = users(:john).id
    @date1    = Date.parse('30-8-2015')
    @date2    = Date.parse('31-8-2015')
    @school1  = schools(:hhs).id
    @school2  = schools(:harper).id
    @lesson   = lessons(:today).id
  end

  test "create" do
    log_in_as users(:michael)
    # Invalid submission
    assert_no_difference ['Goal.count', 'Lesson.count'] do
      post :create, lesson: { date: @date1,
                              school_id: @school1,
                              goals_attributes: {'0' => { text: '',
                                                          user_id: @user1 }}}
    end
    # Valid submission
    assert_difference ['Goal.count', 'Lesson.count'] do
      post :create, lesson: { date: @date1,
                              school_id: @school1,
                              goals_attributes: {'0' => { text: 'golazo!',
                                                          user_id: @user1 }}}
    end
    # Same date, different school
    assert_difference ['Goal.count', 'Lesson.count'] do
      post :create, lesson: { date: @date1,
                              school_id: @school2,
                              goals_attributes: {'0' => { text: 'golazo!',
                                                          user_id: @user1 }}}
    end
    # Different date, same school
    assert_difference ['Goal.count', 'Lesson.count'] do
      post :create, lesson: { date: @date2,
                              school_id: @school1,
                              goals_attributes: {'0' => { text: 'golazo!',
                                                          user_id: @user1 }}}
    end
    # Same user, same date, same school
    assert_no_difference ['Goal.count', 'Lesson.count'] do
      post :create, lesson: { date: @date2,
                              school_id: @school1,
                              goals_attributes: {'0' => { text: 'golazo!',
                                                          user_id: @user1 }}}
    end
    # Different user, same date, same school
    log_in_as users(:john)
    assert_differences [['Goal.count', 1], ['Lesson.count', 0]] do
      post :create, lesson: { date: @date1,
                              school_id: @school1,
                              goals_attributes: {'0' => { text: 'golazo!',
                                                          user_id: @user2 }}}
    end
  end

  test "remove user" do
    # with multiple goals in the Lesson
    log_in_as users(:michael)
    assert_differences [['Lesson.count', 0], ['Goal.count', -1]] do
      delete :remove_user, id: @lesson
    end
    # with only one goal
    log_in_as users(:john)
    assert_differences [['Lesson.count', -1], ['Goal.count', -1]] do
      delete :remove_user, id: @lesson
    end
  end
end
