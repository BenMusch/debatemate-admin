require 'test_helper'

class SetDaysTestTest < ActionDispatch::IntegrationTest

    def setup
      @michael = users(:michael)
      @john    = users(:john)
    end

    test "set_days" do
      # first submission
      michael_days = {}
      john_days = {}
      ids = {}
      params = {}
      michael_days["monday"] = "true"
      michael_days["wednesday"] = "true"
      john_days["thursday"] = "true"
      ids[@michael.id.to_s] = michael_days
      ids[@john.id.to_s]  = john_days
      params["days"] = ids
      post set_days_path, params
      @michael.reload
      @john.reload
      assert     @michael.monday?
      assert_not @michael.tuesday?
      assert     @michael.wednesday?
      assert_not @michael.thursday?
      assert_not @michael.friday?
      assert_not @john.monday?
      assert_not @john.tuesday?
      assert_not @john.wednesday?
      assert     @john.thursday?
      assert_not @john.friday?
      # undo first submission, add other stuff
      michael_days.clear
      michael_days["friday"] = "true"
      post set_days_path, params
      @michael.reload
      @john.reload
      assert_not @michael.monday?
      assert_not @michael.tuesday?
      assert_not @michael.wednesday?
      assert_not @michael.thursday?
      assert     @michael.friday?
      assert_not @john.monday?
      assert_not @john.tuesday?
      assert_not @john.wednesday?
      assert     @john.thursday?
      assert_not @john.friday?
    end
end
