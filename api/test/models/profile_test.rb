require 'test_helper'

class ProfileTest < ActiveSupport::TestCase
  def setup
    @valid_profile = Profile.create(
      name: 'ruby matz',
      url: 'https://github.com/matz'
    )
    @alt_valid_profile = Profile.create(
      name: 'newly joined user',
      url: 'https://github.com/newbie-test-case'
    )
  end

  # tests using the scrapping function,
  # these might take some time to run

  test "should create profile" do
    assert('https://github.com/matz' != @valid_profile.url)
    assert_equal(@valid_profile.username, 'matz')
    assert(Profile.find_by_name('ruby matz'))
  end

  test "should delete profile" do
    before = Profile.count()
    @valid_profile.destroy

    assert(Profile.count() == before - 1)
  end

  test "should edit profile" do
    old_username = @valid_profile.username
    old_url = @valid_profile.url

    before_update_count = Profile.count()

    @valid_profile.update(name: 'matsuda', url: @valid_profile.url)

    assert_equal(old_username, @valid_profile.username)
    assert_equal(old_url, @valid_profile.url)

    assert_equal(@valid_profile.name, 'matsuda')
    assert_equal(before_update_count, Profile.count())
  end

  # profile validation tests

  test "should raise validation error in case of unexisting github profile" do
    before = Profile.count()

    b = Profile.create(
      name: 'test case name',
      url: 'https://github.com/someunexistinguser666b'
    )

    assert(b.errors.key?('404'))
    assert(before == Profile.count())
  end

  test "should validate profiles" do
    assert(@valid_profile.valid?)
    assert(@alt_valid_profile.valid?)
  end

  test "should not create nor update profile without name" do
    before = Profile.count()

    Profile.create(name: nil, url: 'https://github.com/andre')
    Profile.create(name: '', url: 'https://github.com/andre')
    assert_equal(before, Profile.count())

    assert_equal(@valid_profile.update(name: '', url: @valid_profile.url), false)
    assert_equal(@valid_profile.update(name: nil, url: @valid_profile.url), false)

  end

  test "should not create nor update profile without url" do
    before = Profile.count()

    assert(!Profile.create(url: nil).valid?)
    assert(!Profile.create(url: '').valid?)
    assert_equal(@valid_profile.update(url: nil), false)
    assert_equal(@valid_profile.update(url: ''), false)

    assert_equal(before, Profile.count())
  end

end
