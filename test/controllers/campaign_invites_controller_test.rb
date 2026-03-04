require "test_helper"

class CampaignInvitesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @campaign = campaigns(:one)
    @game_master = users(:one)
    @player = users(:two)
  end

  # --- Authentication ---

  test "redirects unauthenticated user" do
    get new_campaign_campaign_invite_path(@campaign)
    assert_redirected_to new_session_path
  end

  # --- new ---

  test "game master can access the invite form" do
    sign_in_as @game_master
    get new_campaign_campaign_invite_path(@campaign)
    assert_response :success
  end

  test "non-game-master cannot access the invite form" do
    sign_in_as @player
    get new_campaign_campaign_invite_path(@campaign)
    assert_redirected_to campaigns_path
  end

  # --- create ---

  test "game master can send invites to one or more users" do
    sign_in_as @game_master
    assert_difference "CampaignInvite.count" do
      post campaign_campaign_invites_path(@campaign), params: { user_ids: [ users(:three).id ] }
    end
    assert_redirected_to @campaign
  end

  test "create with no user_ids does not create any invites" do
    sign_in_as @game_master
    assert_no_difference "CampaignInvite.count" do
      post campaign_campaign_invites_path(@campaign), params: {}
    end
    assert_redirected_to @campaign
  end

  test "non-game-master cannot send invites" do
    sign_in_as @player
    assert_no_difference "CampaignInvite.count" do
      post campaign_campaign_invites_path(@campaign), params: { user_ids: [ users(:three).id ] }
    end
    assert_redirected_to campaigns_path
  end

  # --- update (accept / decline) ---

  test "invited user can accept a campaign invite" do
    sign_in_as @player
    invite = campaign_invites(:pending)  # user two, campaign one, pending
    patch campaign_campaign_invite_path(@campaign, invite), params: { campaign_invite: { status: "accepted" } }
    assert_redirected_to root_path
    assert_equal "accepted", invite.reload.status
  end

  # --- destroy ---

  test "game master can revoke an invite" do
    sign_in_as @game_master
    invite = campaign_invites(:pending)
    assert_difference "CampaignInvite.count", -1 do
      delete campaign_campaign_invite_path(@campaign, invite)
    end
  end

  test "non-game-master cannot revoke an invite" do
    sign_in_as @player
    invite = campaign_invites(:pending)
    assert_no_difference "CampaignInvite.count" do
      delete campaign_campaign_invite_path(@campaign, invite)
    end
    assert_redirected_to campaigns_path
  end
end
