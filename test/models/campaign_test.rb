require "test_helper"

class CampaignTest < ActiveSupport::TestCase
  test "belongs to game master" do
    assert_equal users(:one), campaigns(:one).game_master
  end

  test "has and belongs to many users" do
    assert_includes campaigns(:one).users, users(:one)
    assert_includes campaigns(:one).users, users(:two)
  end

  test "has many locations" do
    assert_includes campaigns(:one).locations, locations(:one)
  end

  test "has many non_player_characters" do
    assert_includes campaigns(:one).non_player_characters, non_player_characters(:one)
  end

  test "has many player_characters" do
    assert_includes campaigns(:one).player_characters, player_characters(:one)
  end

  test "has one character_sheet_template" do
    assert_equal character_sheet_templates(:one), campaigns(:one).character_sheet_template
  end

  test "pending_invites returns pending campaign invites" do
    assert_includes campaigns(:one).pending_invites, campaign_invites(:pending)
  end

  test "pending_invites excludes accepted invites" do
    assert_not_includes campaigns(:two).pending_invites, campaign_invites(:accepted)
  end

  test "destroying campaign destroys dependent records" do
    assert_difference [ "Location.count", "NonPlayerCharacter.count", "PlayerCharacter.count" ], -1 do
      campaigns(:one).destroy
    end
  end
end
