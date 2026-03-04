require "test_helper"

class PlayerCharacterTest < ActiveSupport::TestCase
  test "belongs to campaign" do
    assert_equal campaigns(:one), player_characters(:one).campaign
  end

  test "belongs to user" do
    assert_equal users(:one), player_characters(:one).user
  end

  test "has one character sheet" do
    assert_equal character_sheets(:one), player_characters(:one).character_sheet
  end

  test "destroying player character destroys its character sheet" do
    assert_difference "CharacterSheet.count", -1 do
      player_characters(:one).destroy
    end
  end
end
