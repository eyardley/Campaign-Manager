class CreateJoinTableLocationsNonPlayerCharacters < ActiveRecord::Migration[8.1]
  def change
    create_join_table :locations, :non_player_characters do |t|
      # t.index [:location_id, :non_player_character_id]
      # t.index [:non_player_character_id, :location_id]
    end
  end
end
