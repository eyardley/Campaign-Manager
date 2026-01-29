class CreateNonPlayerCharacters < ActiveRecord::Migration[8.1]
  def change
    create_table :non_player_characters do |t|
      t.string :name
      t.belongs_to :campaign, null: false, foreign_key: true

      t.timestamps
    end
  end
end
