require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(
      name: "Example User", 
      email: "someone@example.com",
      password: "foobar",
      password_confirmation: "foobar"
    ) 
  end

  test "should be valid" do
    assert @user.valid?
  end

  test "name should be present" do
    @user.name = ""
    assert_not @user.valid?
  end

  test "email should be present" do
    @user.email= "      "
    assert_not @user.valid?
  end

  test "name should be shorter than 50 characters" do
    @user.name = "a" * 51
    assert_not @user.valid?
  end

  test "email should be shorter than 200 characters" do
    @user.email= "a" * 201 
    assert_not @user.valid?
  end

  test "should accept valid email addresses" do 
    valid_addresses = %w[
      user@example.co 
      USER@FOO.com 
      user@foo.COM 
      A_US-ER@foo.bar.org 
      first.last@foo.jp  
      alice+bob@baz.cn
      ]

    valid_addresses.each do |addr|
      @user.email = addr
      assert @user.valid?, "#{addr.inspect} should be valid"
      end
    end

  test "should reject invalid email addresses" do
    invalid_address = %w[
      user@example,com 
      user_at_foo.org 
      user.name@example.
      foo@bar_baz.com 
      foo@bar+baz.com
    ]
    invalid_address.each do |addr|
      @user.email = addr
      assert_not @user.valid?, "#{addr.inspect} should be invalid"
    end
  end

  test "email addresses shoud be unique" do
    duplicate_user = @user.dup
    @user.save
    duplicate_user.email = @user.email.upcase
    assert_not duplicate_user.valid?
  end

  test "email should be lowercase" do
    wild_email = "LeEtNoObS@oMg.CoM"
    @user.email = wild_email
    @user.save
    assert_equal wild_email.downcase, @user.reload.email
  end

  test "password shoud be present (nonblank)" do
    @user.password = @user.password_confirmation = " " * 6
    assert_not @user.valid?
  end

  test "password should have minimum length" do
    @user.password = @user.password_confirmation = "a" * 5
    assert_not @user.valid?
  end

end
