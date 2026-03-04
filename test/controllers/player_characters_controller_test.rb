require "test_helper"

class PlayerCharactersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @campaign = campaigns(:one)
    @pc = player_characters(:one)    # owned by users(:one)
    @owner = users(:one)
    @other_member = users(:two)      # in campaign one but doesn't own this PC
    @outsider = users(:three)
  end

  # --- Authentication ---

  test "redirects unauthenticated user" do
    get campaign_player_character_path(@campaign, @pc)
    assert_redirected_to new_session_path
  end

  # --- show ---

  test "campaign member can view a player character" do
    sign_in_as @other_member
    get campaign_player_character_path(@campaign, @pc)
    assert_response :success
  end

  test "non-member cannot view a player character" do
    sign_in_as @outsider
    get campaign_player_character_path(@campaign, @pc)
    assert_redirected_to root_path
  end

  # --- new ---

  test "campaign member can access new player character form" do
    sign_in_as @owner
    get new_campaign_player_character_path(@campaign)
    assert_response :success
  end

  test "non-member cannot access new player character form" do
    sign_in_as @outsider
    get new_campaign_player_character_path(@campaign)
    assert_redirected_to root_path
  end

  # --- create ---

  test "campaign member can create a player character" do
    sign_in_as @owner
    assert_difference "PlayerCharacter.count" do
      post campaign_player_characters_path(@campaign), params: { player_character: { name: "Gandalf" } }
    end
    assert_redirected_to campaign_player_character_path(@campaign, PlayerCharacter.last)
  end

  test "create sets current user as the player character owner" do
    sign_in_as @owner
    post campaign_player_characters_path(@campaign), params: { player_character: { name: "Gandalf" } }
    assert_equal @owner, PlayerCharacter.last.user
  end

  # --- edit ---

  test "PC owner can access edit form" do
    sign_in_as @owner
    get edit_campaign_player_character_path(@campaign, @pc)
    assert_response :success
  end

  test "non-owner cannot access PC edit form" do
    sign_in_as @other_member
    get edit_campaign_player_character_path(@campaign, @pc)
    assert_redirected_to campaigns_path
  end

  # --- update ---

  test "PC owner can update their character" do
    sign_in_as @owner
    patch campaign_player_character_path(@campaign, @pc), params: { player_character: { name: "Aragorn" } }
    assert_redirected_to campaign_player_character_path(@campaign, @pc)
    assert_equal "Aragorn", @pc.reload.name
  end

  test "non-owner cannot update a player character" do
    sign_in_as @other_member
    patch campaign_player_character_path(@campaign, @pc), params: { player_character: { name: "Hacked" } }
    assert_redirected_to campaigns_path
    assert_not_equal "Hacked", @pc.reload.name
  end

  # --- destroy ---

  test "PC owner can destroy their character" do
    sign_in_as @owner
    assert_difference "PlayerCharacter.count", -1 do
      delete campaign_player_character_path(@campaign, @pc)
    end
    assert_redirected_to campaign_path(@campaign)
  end

  test "non-owner cannot destroy a player character" do
    sign_in_as @other_member
    assert_no_difference "PlayerCharacter.count" do
      delete campaign_player_character_path(@campaign, @pc)
    end
    assert_redirected_to campaigns_path
  end
end
