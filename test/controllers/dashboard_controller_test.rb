require "test_helper"

class DashboardControllerTest < ActionDispatch::IntegrationTest
  test "redirects unauthenticated user to login" do
    get root_path
    assert_redirected_to new_session_path
  end

  test "authenticated user can access dashboard" do
    sign_in_as users(:one)
    get root_path
    assert_response :success
  end

  test "authenticated user with no campaigns can access dashboard" do
    sign_in_as users(:three)
    get root_path
    assert_response :success
  end
end
