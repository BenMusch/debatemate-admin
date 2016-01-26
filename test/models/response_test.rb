require 'test_helper'

class ResponseTest < ActiveSupport::TestCase
  test "Response subclasses" do
    @bool = BooleanResponse.create
    assert_equal @bool.type, 'BooleanResponse'
    assert_equal @bool.read_attribute(:type), 'BooleanResponse'
  end
end
