require 'test_helper'

class Api::V1::ProfileControllerTest < ActionDispatch::IntegrationTest
  setup do
    @matz = Profile.create(name: 'matsumoto', url: 'https://github.com/matz')
  end

  test 'should create profile' do
    profile_params = {
      name: 'andre filho',
      url: 'https://github.com/andre-filho'
    }

    post(api_v1_profiles_path, params: { profile: profile_params })
    response = JSON.parse(@response.body)

    assert_response :created
    assert(response['name'] == 'andre filho')
    assert(response['username'] == 'andre-filho')
    assert(response['location'] == 'Brasília, Brazil')
  end

  test 'should get a profile by id' do
    get(api_v1_profile_path(id: @matz.id))
    response = JSON.parse(@response.body)

    assert_response :success
    assert(response['name'] == @matz.name)
    assert(response['username'] == @matz.username)
    assert(response['url'] == @matz.url)
    assert(response['image_url'] == @matz.image_url)
    assert(response['location'] == @matz.location)
    assert(response['organizations'] == @matz.organizations)
    assert(response['stars'] == @matz.stars)
    assert(response['contributions'] == @matz.contributions)
    assert(response['followers'] == @matz.followers)
    assert(response['subscriptions'] == @matz.subscriptions)
  end

  test 'should edit a profile' do
    update_params = {
      name: 'matsuo',
      url: @matz.url
    }

    old_matz = @matz

    put(api_v1_profile_path(id: @matz.id), params: { profile: update_params })
    response = JSON.parse(@response.body)

    assert_response :success
    assert(response['name'] == 'matsuo')
    assert(response['username'] == @matz.username)
    assert(response['url'] == @matz.url)
    assert(response['location'] == @matz.location)
    assert(response['organizations'] == @matz.organizations)
  end

  test 'should refresh a profile' do
    # running a update without changes on params,
    # irl changes would be done by webscrapper

    update_params = {
      name: @matz.name,
      url: @matz.url
    }

    old_matz = @matz

    put(api_v1_profile_path(id: @matz.id), params: { profile: update_params })
    response = JSON.parse(@response.body)

    assert_response :success
    assert(response['name'] == old_matz.name)
    assert(response['username'] == old_matz.username)
    assert(response['url'] == old_matz.url)
    assert(response['location'] == old_matz.location)
    assert(response['organizations'] == old_matz.organizations)
  end

  test 'should delete a profile' do
    count = Profile.count()
    delete(api_v1_profile_path(id: @matz.id))

    assert_response :no_content
    assert(count - 1 == Profile.count())
  end

  test 'should search profiles by name, username, organization or location' do
    Profile.create([
      { name: 'andre de sousa', url: 'https://github.com/andre-filho' },
      { name: 'andre lewis', url: 'https://github.com/andre' },
      { name: 'newbie user', url: 'https://github.com/newbie-test-case' },
    ])

    get(search_api_v1_profiles_path, params: { query: 'andre' })
    res_1 = JSON.parse(@response.body)
    assert_response :success

    get(search_api_v1_profiles_path, params: { query: 'sousa' })
    res_2 = JSON.parse(@response.body)
    assert_response :success

    get(search_api_v1_profiles_path, params: { query: 'lewis' })
    res_3 = JSON.parse(@response.body)
    assert_response :success

    get(search_api_v1_profiles_path, params: { query: '' })
    res_4 = JSON.parse(@response.body)
    assert_response :success

    profiles = Profile.all()

    assert(res_1.length == 2)
    assert(res_1.is_a?(Array))

    assert(res_2.length == 1)
    assert(res_2.is_a?(Array))

    assert(res_3.length == 1)
    assert(res_3.is_a?(Array))

    assert(res_4.empty?)
  end

  test 'should not create a profile without name or url' do
    profile_params = {
      name: '',
      url: 'https://github.com/andre-filho'
    }

    post(api_v1_profiles_path, params: { profile: profile_params })
    response = JSON.parse(@response.body)

    assert_response :unprocessable_entity
    assert(response['name'] == ["can't be blank"])

    profile_params = {
      name: 'andre',
      url: ''
    }

    post(api_v1_profiles_path, params: { profile: profile_params })
    response = JSON.parse(@response.body)

    assert_response :unprocessable_entity
    assert(response['url'] == ["can't be blank"])
  end

  test 'should not create a profile if it does not exist on github' do
    profile_params = {
      name: 'placeholder',
      url: 'https://github.com/yellow-citric-jabuticaba'
    }

    post(api_v1_profiles_path, params: { profile: profile_params })
    response = JSON.parse(@response.body)

    assert_response :unprocessable_entity
    assert(response['message'] == 'Profile not found on github!')
  end

  test 'should fail to create organization' do
    profile_params = {
      name: 'placeholder',
      url: 'https://github.com/LynceDev'
    }

    post(api_v1_profiles_path, params: { profile: profile_params })
    response = JSON.parse(@response.body)

    assert_response :unprocessable_entity
    assert(response['message'] == 'Profile not found on github!')
  end
end
