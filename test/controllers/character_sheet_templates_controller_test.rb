require "test_helper"

class CharacterSheetTemplatesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @campaign_one = campaigns(:one)
    @campaign_two = campaigns(:two)
    @template = character_sheet_templates(:one)
    @game_master_one = users(:one)
    @game_master_two = users(:two)
    @player = users(:two) # also game master of campaign two but a player in campaign one
  end

  # --- Authentication ---

  test "redirects unauthenticated user" do
    get new_campaign_character_sheet_template_path(@campaign_one)
    assert_redirected_to new_session_path
  end

  # --- Authorization ---

  test "non-game-master is redirected from all template actions" do
    # users(:two) is a player in campaign one, not the game master
    sign_in_as @game_master_two
    get new_campaign_character_sheet_template_path(@campaign_one)
    assert_redirected_to campaigns_path
  end

  # --- new ---

  test "game master can access new template form" do
    sign_in_as @game_master_one
    get new_campaign_character_sheet_template_path(@campaign_one)
    assert_response :success
  end

  # --- create ---

  test "game master can create a template for their campaign" do
    sign_in_as @game_master_two
    # campaign two has no template yet
    assert_difference "CharacterSheetTemplate.count" do
      post campaign_character_sheet_templates_path(@campaign_two), params: {
        character_sheet_template: { name: "Fighter Sheet", data: '{"strength": "number"}' }
      }
    end
    assert_redirected_to campaign_character_sheet_template_path(@campaign_two, CharacterSheetTemplate.last)
  end

  test "create parses the JSON data string into a hash" do
    sign_in_as @game_master_two
    post campaign_character_sheet_templates_path(@campaign_two), params: {
      character_sheet_template: { name: "Sheet", data: '{"intelligence": "number"}' }
    }
    assert_equal({ "intelligence" => "number" }, CharacterSheetTemplate.last.data)
  end

  # --- show ---

  test "game master can view a template" do
    sign_in_as @game_master_one
    get campaign_character_sheet_template_path(@campaign_one, @template)
    assert_response :success
  end

  # --- edit ---

  test "game master can access edit template form" do
    sign_in_as @game_master_one
    get edit_campaign_character_sheet_template_path(@campaign_one, @template)
    assert_response :success
  end

  # --- update ---

  test "game master can update a template" do
    sign_in_as @game_master_one
    patch campaign_character_sheet_template_path(@campaign_one, @template), params: {
      character_sheet_template: { name: "Revised Template", data: '{"charisma": "number"}' }
    }
    assert_redirected_to campaign_character_sheet_template_path(@campaign_one, @template)
    assert_equal "Revised Template", @template.reload.name
  end

  test "update parses JSON data string" do
    sign_in_as @game_master_one
    patch campaign_character_sheet_template_path(@campaign_one, @template), params: {
      character_sheet_template: { name: @template.name, data: '{"wisdom": "number"}' }
    }
    assert_equal({ "wisdom" => "number" }, @template.reload.data)
  end

  # --- destroy ---

  test "game master can destroy a template" do
    sign_in_as @game_master_one
    assert_difference "CharacterSheetTemplate.count", -1 do
      delete campaign_character_sheet_template_path(@campaign_one, @template)
    end
    assert_redirected_to campaign_path(@campaign_one)
  end
end
