require "test_helper"

class NonPlayerCharacterTest < ActiveSupport::TestCase
  test "belongs to campaign" do
    assert_equal campaigns(:one), non_player_characters(:one).campaign
  end

  test "related_npc_ids returns ids of related NPCs" do
    # npc_to_npc fixture: source=npc_one, target=npc_two
    assert_includes non_player_characters(:one).related_npc_ids, non_player_characters(:two).id
  end

  test "related_location_ids returns ids of related locations" do
    # npc_to_location fixture: source=npc_one, target=location_one
    assert_includes non_player_characters(:one).related_location_ids, locations(:one).id
  end

  test "related_npc_ids= creates relation on create (deferred via after_save)" do
    other = non_player_characters(:two)
    npc = nil
    assert_difference "Relation.count", 1 do
      npc = NonPlayerCharacter.create!(name: "New NPC", campaign: campaigns(:one), related_npc_ids: [ other.id.to_s ])
    end
    assert_includes npc.related_npc_ids, other.id
  end

  test "related_npc_ids= removes NPC relations on update" do
    npc = non_player_characters(:one)
    assert_difference "Relation.count", -1 do
      npc.update!(related_npc_ids: [ "" ])
    end
    assert_empty npc.related_npc_ids
  end

  test "related_location_ids= removes location relations on update" do
    npc = non_player_characters(:one)
    assert_difference "Relation.count", -1 do
      npc.update!(related_location_ids: [ "" ])
    end
    assert_empty npc.related_location_ids
  end
end
