require "test_helper"

class LocationTest < ActiveSupport::TestCase
  test "is valid with name and campaign" do
    location = Location.new(name: "The Tavern", campaign: campaigns(:one))
    assert location.valid?
  end

  test "is invalid without a name" do
    location = Location.new(campaign: campaigns(:one))
    assert_not location.valid?
    assert_includes location.errors[:name], "can't be blank"
  end

  test "belongs to campaign" do
    assert_equal campaigns(:one), locations(:one).campaign
  end

  test "related_npc_ids returns ids of related NPCs" do
    # npc_to_location fixture: source=npc_one, target=location_one
    assert_includes locations(:one).related_npc_ids, non_player_characters(:one).id
  end

  test "related_npc_ids= creates NPC relation on create (deferred via after_save)" do
    npc = non_player_characters(:two)
    location = nil
    assert_difference "Relation.count", 1 do
      location = Location.create!(name: "Cave", campaign: campaigns(:one), related_npc_ids: [ npc.id.to_s ])
    end
    assert_includes location.related_npc_ids, npc.id
  end

  test "related_location_ids= creates location relation on save" do
    new_location = Location.create!(name: "Castle", campaign: campaigns(:one))
    other = locations(:one)
    assert_difference "Relation.count", 1 do
      new_location.update!(related_location_ids: [ other.id.to_s ])
    end
    assert_includes new_location.related_location_ids, other.id
  end

  test "related_npc_ids= removes NPC relations on update" do
    location = locations(:one)
    # npc_to_location fixture exists — passing empty removes it
    assert_difference "Relation.count", -1 do
      location.update!(related_npc_ids: [ "" ])
    end
    assert_empty location.related_npc_ids
  end
end
