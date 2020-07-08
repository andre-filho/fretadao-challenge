require 'test_helper'

class SearchControllerTest < ActionDispatch::IntegrationTest
  test "should get search_profiles" do
    get search_search_profiles_url
    assert_response :success
  end

end
