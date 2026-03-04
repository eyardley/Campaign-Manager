require "test_helper"

class CampaignInviteTest < ActiveSupport::TestCase
  test "belongs to campaign" do
    assert_equal campaigns(:one), campaign_invites(:pending).campaign
  end

  test "belongs to user" do
    assert_equal users(:two), campaign_invites(:pending).user
  end

  test "accepting an invite adds the user to the campaign" do
    # user three has no existing membership in campaign one
    invite = CampaignInvite.create!(campaign: campaigns(:one), user: users(:three), status: "pending")
    assert_not_includes campaigns(:one).users, users(:three)

    invite.update!(status: "accepted")

    assert_includes campaigns(:one).reload.users, users(:three)
  end

  test "accepting does not duplicate an existing campaign member" do
    # user two is already in campaign one via campaigns_users fixture
    invite = campaign_invites(:pending)
    initial_count = campaigns(:one).users.count

    invite.update!(status: "accepted")

    assert_equal initial_count, campaigns(:one).reload.users.count
  end

  test "non-accepted status updates do not add user to campaign" do
    invite = campaign_invites(:pending)
    initial_count = campaigns(:one).users.count

    invite.update!(status: "declined")

    assert_equal initial_count, campaigns(:one).reload.users.count
  end
end
