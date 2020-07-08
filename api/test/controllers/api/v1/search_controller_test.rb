require 'test_helper'

class Api::V1::SearchControllerTest < ActionDispatch::IntegrationTest
  test "should get search_profiles" do
    Profile.create([
      { name: 'andre de sousa', url: 'https://github.com/andre-filho' },
      { name: 'andre lewis', url: 'https://github.com/andre' },
      { name: 'newbie user', url: 'https://github.com/newbie-test-case' },
    ])

    get(api_v1_search_path, params: { query: 'andre' })
    res_1 = JSON.parse(@response.body)
    assert_response :success

    get(api_v1_search_path, params: { query: 'sousa' })
    res_2 = JSON.parse(@response.body)
    assert_response :success

    get(api_v1_search_path, params: { query: 'lewis' })
    res_3 = JSON.parse(@response.body)
    assert_response :success

    get(api_v1_search_path, params: { query: '' })
    res_4 = JSON.parse(@response.body)
    assert_response :success

    assert(res_1.length == 2)
    assert(res_1.is_a?(Array))
    assert(res_2.length == 1)
    assert(res_2.is_a?(Array))
    assert(res_3.length == 1)
    assert(res_3.is_a?(Array))
    assert(res_4.empty?)
  end

end
