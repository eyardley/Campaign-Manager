require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "downcases and strips email_address" do
    user = User.new(email_address: " DOWNCASED@EXAMPLE.COM ")
    assert_equal "downcased@example.com", user.email_address
  end

  test "authenticates with correct password" do
    assert users(:one).authenticate("password")
  end

  test "does not authenticate with wrong password" do
    assert_not users(:one).authenticate("wrong")
  end

  test "friends returns users from accepted friendships" do
    # accepted fixture: user one ↔ user two
    assert_includes users(:one).friends, users(:two)
  end

  test "friends does not include users with only pending requests" do
    assert_not_includes users(:one).friends, users(:three)
  end

  test "friend_requests returns pending friendships where user is the recipient" do
    # pending fixture: user three → friend user one
    assert_includes users(:one).friend_requests, friendships(:pending)
  end

  test "friend_requests does not include accepted friendships" do
    assert_not_includes users(:one).friend_requests, friendships(:accepted)
  end

  test "pending_campaign_invites returns pending invites for the user" do
    # pending fixture: user two, campaign one, status pending
    assert_includes users(:two).pending_campaign_invites, campaign_invites(:pending)
  end

  test "pending_campaign_invites excludes accepted invites" do
    assert_not_includes users(:one).pending_campaign_invites, campaign_invites(:accepted)
  end
end
