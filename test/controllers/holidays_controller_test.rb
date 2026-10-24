require "test_helper"

class HolidaysControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in admins(:one)
  end

  test "should redirect to sign in when not signed in" do
    sign_out :admin
    get new_holiday_url
    assert_redirected_to new_admin_session_url
  end

  test "should get new" do
    get new_holiday_url
    assert_response :success
  end

  test "should create holiday" do
    assert_difference("Holiday.count") do
      post holidays_url, params: { holiday: { title: "店休日", start_time: 5.days.from_now } }
    end
    assert_redirected_to new_holiday_url
  end

  test "should destroy holiday" do
    assert_difference("Holiday.count", -1) do
      delete holiday_url(holidays(:one))
    end
    assert_redirected_to new_holiday_url
  end
end
