require "test_helper"

class StaffsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in admins(:one)
    @staff = staffs(:one)
  end

  test "should redirect to sign in when not signed in" do
    sign_out :admin
    get staffs_url
    assert_redirected_to new_admin_session_url
  end

  test "should get index" do
    get staffs_url
    assert_response :success
  end

  test "should get new" do
    get new_staff_url
    assert_response :success
  end

  test "should create staff" do
    assert_difference("Staff.count") do
      post staffs_url, params: { staff: { name: "スタッフ3" } }
    end
    assert_redirected_to staffs_url
  end

  test "should get edit" do
    get edit_staff_url(@staff)
    assert_response :success
  end

  test "should update staff" do
    patch staff_url(@staff), params: { staff: { name: "スタッフ1改" } }
    assert_redirected_to staffs_url
    assert_equal "スタッフ1改", @staff.reload.name
  end

  test "should destroy staff" do
    assert_difference("Staff.count", -1) do
      delete staff_url(@staff)
    end
    assert_redirected_to staffs_url
  end
end
