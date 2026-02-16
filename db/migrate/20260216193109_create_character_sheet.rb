class CreateCharacterSheet < ActiveRecord::Migration[8.1]
  def change
    create_table :character_sheets do |t|
      t.belongs_to :player_character, null: false, foreign_key: true
      t.jsonb :data, default: {}

      t.timestamps
    end
  end
end
