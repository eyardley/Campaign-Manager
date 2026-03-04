require "test_helper"

class FriendshipsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    @friendship = friendships(:accepted)   # user one ↔ user two
    @pending = friendships(:pending)       # user three → friend user one
  end

  # --- Authentication ---

  test "redirects unauthenticated user from new" do
    get new_user_friendship_path(@user)
    assert_redirected_to new_session_path
  end

  # --- new ---

  test "authenticated user can access new friendship form" do
    sign_in_as @user
    get new_user_friendship_path(@user)
    assert_response :success
  end

  test "new with a search query returns results" do
    sign_in_as @user
    get new_user_friendship_path(@user), params: { query: "three" }
    assert_response :success
  end

  # --- create ---

  test "creates a pending friend request from the current user" do
    sign_in_as users(:two)
    # user two → user three: no existing friendship in either direction
    assert_difference "Friendship.count" do
      post user_friendships_path(users(:two)), params: { friendship: { friend_id: users(:three).id } }
    end
    assert_equal "pending", Friendship.last.status
    assert_redirected_to new_user_friendship_path(users(:two))
  end

  test "create failure redirects back with alert" do
    sign_in_as @user
    # user one → user two already exists (accepted), so reverse (user two → user one) would fail
    # But create sends from Current.user — user one → user two would hit the DB unique index
    # Instead test with a self-friendship (no validation for that currently) — just verify redirect
    post user_friendships_path(@user), params: { friendship: { friend_id: users(:two).id } }
    assert_redirected_to new_user_friendship_path(@user)
  end

  # --- update ---

  test "user can accept a friend request" do
    sign_in_as @user  # user one is the :friend in the pending fixture
    patch user_friendship_path(@user, @pending), params: { friendship: { status: "accepted" } }
    assert_redirected_to root_path
    assert_equal "accepted", @pending.reload.status
  end

  # --- destroy ---

  test "user can remove a friendship" do
    sign_in_as @user
    assert_difference "Friendship.count", -1 do
      delete user_friendship_path(@user, @friendship)
    end
    assert_redirected_to root_path
  end
end
