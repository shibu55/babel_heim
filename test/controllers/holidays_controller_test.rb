require "test_helper"

class HolidaysControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get holidays_index_url
    assert_response :success
  end
end
