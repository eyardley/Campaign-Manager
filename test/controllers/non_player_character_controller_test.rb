require "test_helper"

# Note: filename is singular due to legacy naming; class uses the correct plural form.
class NonPlayerCharactersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @campaign = campaigns(:one)
    @npc = non_player_characters(:one)
    @game_master = users(:one)
    @player = users(:two)
    @outsider = users(:three)
  end

  # --- Authentication ---

  test "redirects unauthenticated user" do
    get campaign_non_player_character_path(@campaign, @npc)
    assert_redirected_to new_session_path
  end

  # --- show ---

  test "game master can view NPC" do
    sign_in_as @game_master
    get campaign_non_player_character_path(@campaign, @npc)
    assert_response :success
  end

  test "campaign player can view NPC" do
    sign_in_as @player
    get campaign_non_player_character_path(@campaign, @npc)
    assert_response :success
  end

  test "non-member cannot view NPC" do
    sign_in_as @outsider
    get campaign_non_player_character_path(@campaign, @npc)
    assert_redirected_to root_path
  end

  # --- new ---

  test "game master can access new NPC form" do
    sign_in_as @game_master
    get new_campaign_non_player_character_path(@campaign)
    assert_response :success
  end

  test "non-game-master cannot access new NPC form" do
    sign_in_as @player
    get new_campaign_non_player_character_path(@campaign)
    assert_redirected_to campaigns_path
  end

  # --- create ---

  test "game master can create an NPC" do
    sign_in_as @game_master
    assert_difference "NonPlayerCharacter.count" do
      post campaign_non_player_characters_path(@campaign), params: {
        non_player_character: { name: "New NPC" }
      }
    end
    assert_redirected_to campaign_non_player_character_path(@campaign, NonPlayerCharacter.last)
  end

  test "create associates NPC with the campaign" do
    sign_in_as @game_master
    post campaign_non_player_characters_path(@campaign), params: {
      non_player_character: { name: "New NPC" }
    }
    assert_equal @campaign, NonPlayerCharacter.last.campaign
  end

  test "create with related NPC and location creates the correct number of relations" do
    sign_in_as @game_master
    assert_difference "NonPlayerCharacter.count", 1 do
      assert_difference "Relation.count", 2 do
        post campaign_non_player_characters_path(@campaign), params: {
          non_player_character: {
            name: "New NPC",
            related_npc_ids: [ non_player_characters(:two).id.to_s ],
            related_location_ids: [ locations(:one).id.to_s ]
          }
        }
      end
    end
  end

  # --- edit ---

  test "game master can access NPC edit form" do
    sign_in_as @game_master
    get edit_campaign_non_player_character_path(@campaign, @npc)
    assert_response :success
  end

  # --- update ---

  test "game master can update NPC name" do
    sign_in_as @game_master
    patch campaign_non_player_character_path(@campaign, @npc), params: {
      non_player_character: { name: "Updated NPC" }
    }
    assert_redirected_to campaign_non_player_character_path(@campaign, @npc)
    assert_equal "Updated NPC", @npc.reload.name
  end

  test "update with empty relation arrays removes existing relations" do
    sign_in_as @game_master
    # npc_to_npc and npc_to_location fixtures = 2 existing relations for @npc
    assert_difference "Relation.count", -2 do
      patch campaign_non_player_character_path(@campaign, @npc), params: {
        non_player_character: {
          name: @npc.name,
          related_npc_ids: [ "" ],
          related_location_ids: [ "" ]
        }
      }
    end
  end

  test "non-game-master cannot update NPC" do
    sign_in_as @player
    patch campaign_non_player_character_path(@campaign, @npc), params: {
      non_player_character: { name: "Hacked" }
    }
    assert_redirected_to campaigns_path
    assert_not_equal "Hacked", @npc.reload.name
  end

  # --- destroy ---

  test "game master can destroy NPC" do
    sign_in_as @game_master
    assert_difference "NonPlayerCharacter.count", -1 do
      delete campaign_non_player_character_path(@campaign, @npc)
    end
    assert_redirected_to campaign_path(@campaign)
  end

  test "non-game-master cannot destroy NPC" do
    sign_in_as @player
    assert_no_difference "NonPlayerCharacter.count" do
      delete campaign_non_player_character_path(@campaign, @npc)
    end
    assert_redirected_to campaigns_path
  end
end
