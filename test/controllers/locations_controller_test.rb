require "test_helper"

class LocationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @campaign = campaigns(:one)
    @location = locations(:one)
    @game_master = users(:one)
    @player = users(:two)
    @outsider = users(:three)
  end

  # --- Authentication ---

  test "redirects unauthenticated user" do
    get campaign_location_path(@campaign, @location)
    assert_redirected_to new_session_path
  end

  # --- show ---

  test "game master can view location" do
    sign_in_as @game_master
    get campaign_location_path(@campaign, @location)
    assert_response :success
  end

  test "campaign player can view location" do
    sign_in_as @player
    get campaign_location_path(@campaign, @location)
    assert_response :success
  end

  test "non-member cannot view location" do
    sign_in_as @outsider
    get campaign_location_path(@campaign, @location)
    assert_redirected_to root_path
  end

  # --- new ---

  test "game master can access new location form" do
    sign_in_as @game_master
    get new_campaign_location_path(@campaign)
    assert_response :success
  end

  test "non-game-master cannot access new location form" do
    sign_in_as @player
    get new_campaign_location_path(@campaign)
    assert_redirected_to campaigns_path
  end

  # --- create ---

  test "game master can create a location" do
    sign_in_as @game_master
    assert_difference "Location.count" do
      post campaign_locations_path(@campaign), params: { location: { name: "The Tavern" } }
    end
    assert_redirected_to campaign_location_path(@campaign, Location.last)
  end

  test "create with missing name renders new with error" do
    sign_in_as @game_master
    assert_no_difference "Location.count" do
      post campaign_locations_path(@campaign), params: { location: { name: "" } }
    end
    assert_response :unprocessable_entity
  end

  # --- edit ---

  test "game master can access location edit form" do
    sign_in_as @game_master
    get edit_campaign_location_path(@campaign, @location)
    assert_response :success
  end

  test "non-game-master cannot access location edit form" do
    sign_in_as @player
    get edit_campaign_location_path(@campaign, @location)
    assert_redirected_to campaigns_path
  end

  # --- update ---

  test "game master can update location" do
    sign_in_as @game_master
    patch campaign_location_path(@campaign, @location), params: { location: { name: "Updated Place" } }
    assert_redirected_to campaign_location_path(@campaign, @location)
    assert_equal "Updated Place", @location.reload.name
  end

  test "non-game-master cannot update location" do
    sign_in_as @player
    patch campaign_location_path(@campaign, @location), params: { location: { name: "Hacked" } }
    assert_redirected_to campaigns_path
    assert_not_equal "Hacked", @location.reload.name
  end

  # --- destroy ---

  test "game master can destroy location" do
    sign_in_as @game_master
    assert_difference "Location.count", -1 do
      delete campaign_location_path(@campaign, @location)
    end
    assert_redirected_to campaign_path(@campaign)
  end

  test "non-game-master cannot destroy location" do
    sign_in_as @player
    assert_no_difference "Location.count" do
      delete campaign_location_path(@campaign, @location)
    end
    assert_redirected_to campaigns_path
  end
end
