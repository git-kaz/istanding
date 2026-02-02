require "test_helper"

class SittingSessionsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get sitting_sessions_new_url
    assert_response :success
  end

  test "should get show" do
    get sitting_sessions_show_url
    assert_response :success
  end
end
