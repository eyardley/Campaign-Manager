require "test_helper"

class RelationTest < ActiveSupport::TestCase
  test "has a polymorphic source" do
    relation = relations(:npc_to_npc)
    assert_equal non_player_characters(:one), relation.source
    assert_equal "NonPlayerCharacter", relation.source_type
  end

  test "has a polymorphic target" do
    relation = relations(:npc_to_npc)
    assert_equal non_player_characters(:two), relation.target
    assert_equal "NonPlayerCharacter", relation.target_type
  end

  test "can relate an NPC to a Location" do
    relation = relations(:npc_to_location)
    assert_equal non_player_characters(:one), relation.source
    assert_equal locations(:one), relation.target
    assert_equal "Location", relation.target_type
  end
end
