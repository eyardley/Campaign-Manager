require "test_helper"

class CharacterSheetTemplateTest < ActiveSupport::TestCase
  test "belongs to campaign" do
    assert_equal campaigns(:one), character_sheet_templates(:one).campaign
  end

  test "has many character sheets" do
    assert_includes character_sheet_templates(:one).character_sheets, character_sheets(:one)
  end

  test "to_character_sheet transforms each field into a type/value hash" do
    result = character_sheet_templates(:one).to_character_sheet
    # data has keys: strength, dexterity, hit_points
    assert_equal 3, result.size
    result.each_value do |v|
      assert_includes v.keys.map(&:to_s), "type"
      assert_includes v.keys.map(&:to_s), "value"
      assert_equal "", v[:value]
    end
  end

  test "to_character_sheet preserves original field type values" do
    result = character_sheet_templates(:one).to_character_sheet
    assert_equal "number", result["strength"][:type]
  end

  test "destroying template destroys dependent character sheets" do
    assert_difference "CharacterSheet.count", -1 do
      character_sheet_templates(:one).destroy
    end
  end
end
