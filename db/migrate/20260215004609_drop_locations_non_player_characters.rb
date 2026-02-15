class DropLocationsNonPlayerCharacters < ActiveRecord::Migration[8.1]
  def change
    drop_table :locations_non_player_characters
  end
end
