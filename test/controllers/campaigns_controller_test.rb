require "test_helper"

class CampaignsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @campaign = campaigns(:one)
    @game_master = users(:one)
    @player = users(:two)   # member of campaign one but not game master
    @outsider = users(:three) # not a member of any campaign
  end

  # --- Authentication ---

  test "redirects unauthenticated user from show" do
    get campaign_path(@campaign)
    assert_redirected_to new_session_path
  end

  # --- show ---

  test "game master can view their campaign" do
    sign_in_as @game_master
    get campaign_path(@campaign)
    assert_response :success
  end

  test "player can view a campaign they belong to" do
    sign_in_as @player
    get campaign_path(@campaign)
    assert_response :success
  end

  test "non-member is redirected from show" do
    sign_in_as @outsider
    get campaign_path(@campaign)
    assert_redirected_to root_path
  end

  # --- new ---

  test "authenticated user can access new campaign form" do
    sign_in_as @game_master
    get new_campaign_path
    assert_response :success
  end

  # --- create ---

  test "create builds a campaign and redirects to it" do
    sign_in_as @game_master
    assert_difference "Campaign.count" do
      post campaigns_path, params: { campaign: { name: "New Campaign" } }
    end
    assert_redirected_to campaign_path(Campaign.last)
  end

  test "create sets current user as game master" do
    sign_in_as @game_master
    post campaigns_path, params: { campaign: { name: "New Campaign" } }
    assert_equal @game_master, Campaign.last.game_master
  end

  test "create adds current user to campaign members" do
    sign_in_as @game_master
    post campaigns_path, params: { campaign: { name: "New Campaign" } }
    assert_includes Campaign.last.users, @game_master
  end

  # --- edit ---

  test "game master can access campaign edit form" do
    sign_in_as @game_master
    get edit_campaign_path(@campaign)
    assert_response :success
  end

  test "non-game-master is redirected from edit" do
    sign_in_as @player
    get edit_campaign_path(@campaign)
    assert_redirected_to campaigns_path
  end

  # --- update ---

  test "game master can update campaign" do
    sign_in_as @game_master
    patch campaign_path(@campaign), params: { campaign: { name: "Updated Name" } }
    assert_redirected_to campaign_path(@campaign)
    assert_equal "Updated Name", @campaign.reload.name
  end

  test "non-game-master cannot update campaign" do
    sign_in_as @player
    patch campaign_path(@campaign), params: { campaign: { name: "Hacked" } }
    assert_redirected_to campaigns_path
    assert_not_equal "Hacked", @campaign.reload.name
  end

  # --- destroy ---

  test "game master can destroy campaign" do
    sign_in_as @game_master
    assert_difference "Campaign.count", -1 do
      delete campaign_path(@campaign)
    end
    assert_redirected_to campaigns_path
  end

  test "non-game-master cannot destroy campaign" do
    sign_in_as @player
    assert_no_difference "Campaign.count" do
      delete campaign_path(@campaign)
    end
    assert_redirected_to campaigns_path
  end
end
