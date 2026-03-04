require "test_helper"

class CharacterSheetTest < ActiveSupport::TestCase
  test "belongs to player character" do
    assert_equal player_characters(:one), character_sheets(:one).player_character
  end

  test "belongs to character sheet template" do
    assert_equal character_sheet_templates(:one), character_sheets(:one).character_sheet_template
  end

  test "sync_with_template removes fields not present in template" do
    sheet = character_sheets(:one)
    sheet.data["obsolete_field"] = { "type" => "text", "value" => "old data" }
    sheet.sync_with_template
    assert_nil sheet.data["obsolete_field"]
  end

  test "sync_with_template adds new template fields with empty values" do
    sheet = character_sheets(:one)
    # Template has hit_points; sheet fixture only has strength + dexterity
    sheet.sync_with_template
    assert_includes sheet.data.keys, "hit_points"
    # sync_with_template uses symbol keys for new fields
    new_field = sheet.data["hit_points"]
    assert_equal "", new_field[:value] || new_field["value"]
  end

  test "sync_with_template preserves existing field values" do
    sheet = character_sheets(:one)
    sheet.sync_with_template
    # strength was already in the sheet — its value should be preserved
    assert_equal "10", sheet.data["strength"]["value"]
  end
end
