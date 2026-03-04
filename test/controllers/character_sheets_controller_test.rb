require "test_helper"

class CharacterSheetsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @campaign = campaigns(:one)
    @pc = player_characters(:one)
    @sheet = character_sheets(:one)
    @owner = users(:one)
    @other_member = users(:two) # in campaign one but does not own this PC
  end

  # --- Authentication ---

  test "redirects unauthenticated user" do
    get new_campaign_player_character_character_sheet_path(@campaign, @pc)
    assert_redirected_to new_session_path
  end

  # --- Authorization ---

  test "non-PC-owner is redirected from all character sheet actions" do
    sign_in_as @other_member
    get new_campaign_player_character_character_sheet_path(@campaign, @pc)
    assert_redirected_to campaigns_path
  end

  # --- new ---

  test "PC owner can access new character sheet form" do
    sign_in_as @owner
    @sheet.destroy  # remove existing sheet so new is accessible
    get new_campaign_player_character_character_sheet_path(@campaign, @pc)
    assert_response :success
  end

  # --- create ---

  test "PC owner can create a character sheet" do
    sign_in_as @owner
    @sheet.destroy  # remove existing sheet so we can create a fresh one
    sheet_data = { "strength" => { "type" => "number", "value" => "10" } }.to_json
    assert_difference "CharacterSheet.count" do
      post campaign_player_character_character_sheets_path(@campaign, @pc), params: {
        character_sheet: { data: sheet_data }
      }
    end
    assert_redirected_to campaign_player_character_path(@campaign, @pc)
  end

  # --- edit ---

  test "PC owner can access character sheet edit form" do
    sign_in_as @owner
    get edit_campaign_player_character_character_sheet_path(@campaign, @pc, @sheet)
    assert_response :success
  end

  # --- update ---

  test "PC owner can update character sheet data" do
    sign_in_as @owner
    new_data = { "strength" => { "type" => "number", "value" => "18" } }.to_json
    patch campaign_player_character_character_sheet_path(@campaign, @pc, @sheet), params: {
      character_sheet: { data: new_data }
    }
    assert_redirected_to campaign_player_character_path(@campaign, @pc)
    assert_equal 18, @sheet.reload.data.dig("strength", "value").to_i
  end

  # --- destroy ---

  test "PC owner can destroy a character sheet" do
    sign_in_as @owner
    assert_difference "CharacterSheet.count", -1 do
      delete campaign_player_character_character_sheet_path(@campaign, @pc, @sheet)
    end
    assert_redirected_to campaign_player_character_path(@campaign, @pc)
  end
end
