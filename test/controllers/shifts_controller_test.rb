require "test_helper"

class ShiftsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in admins(:one)
    @shift = shifts(:one)
  end

  test "should redirect to sign in when not signed in" do
    sign_out :admin
    get shifts_url
    assert_redirected_to new_admin_session_url
  end

  test "should get index" do
    get shifts_url
    assert_response :success
  end

  test "should create shift" do
    assert_difference("Shift.count") do
      post shifts_url, params: { shift: { staff_id: staffs(:one).id, start_time: 5.days.from_now } }
    end
    assert_redirected_to shifts_url
  end

  test "should get edit" do
    get edit_shift_url(@shift)
    assert_response :success
  end

  test "should update shift" do
    patch shift_url(@shift), params: { shift: { staff_id: staffs(:two).id } }
    assert_redirected_to shifts_url
    assert_equal staffs(:two), @shift.reload.staff
  end

  test "should destroy shift" do
    assert_difference("Shift.count", -1) do
      delete shift_url(@shift)
    end
    assert_redirected_to shifts_url
  end
end
