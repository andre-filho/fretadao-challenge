require 'test_helper'

class ProfileTest < ActiveSupport::TestCase

  test "should create profile" do
    Profile.create()
  end

  test "should not create profile without name" do

  end

  test "should not create profile without github username" do

  end

  test "should not create profile without url" do

  end

  test "should not create profile without image url" do

  end

  test "should not create profile without github followers" do

  end

  test "should not create profile without github stars" do

  end

  test "should not create profile without github contributions" do

  end

  test "should raise validation error in case of unexisting github profile" do

  end
end
