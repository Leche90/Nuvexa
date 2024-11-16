require "test_helper"

class Admin::ProvincesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get admin_provinces_index_url
    assert_response :success
  end

  test "should get edit" do
    get admin_provinces_edit_url
    assert_response :success
  end

  test "should get update" do
    get admin_provinces_update_url
    assert_response :success
  end
end
