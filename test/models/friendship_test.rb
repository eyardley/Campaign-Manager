require "test_helper"

class FriendshipTest < ActiveSupport::TestCase
  test "is valid with user, friend, and status" do
    # user two → user three: no existing friendship in either direction
    friendship = Friendship.new(user: users(:two), friend: users(:three))
    assert friendship.valid?
  end

  test "fixtures have correct statuses" do
    assert_equal "accepted", friendships(:accepted).status
    assert_equal "pending", friendships(:pending).status
  end

  test "belongs to user" do
    assert_equal users(:one), friendships(:accepted).user
  end

  test "belongs to friend" do
    assert_equal users(:two), friendships(:accepted).friend
  end

  test "prevents creating the reverse of an existing friendship" do
    # accepted fixture: user one → friend two
    # Trying to create user two → friend one should fail
    reverse = Friendship.new(user: users(:two), friend: users(:one))
    assert_not reverse.valid?
    assert_includes reverse.errors[:base], "A friendship with this user already exists"
  end

  test "allows friendship between users with no existing relation" do
    friendship = Friendship.new(user: users(:two), friend: users(:three))
    assert friendship.valid?
  end

  test "no_reverse_friendship validation only runs on create" do
    # Updating an existing friendship should not re-run the reverse check
    friendship = friendships(:accepted)
    assert friendship.update(status: "pending")
  end
end
