class CreateCharacterSheetTemplate < ActiveRecord::Migration[8.1]
  def change
    create_table :character_sheet_templates do |t|
      t.belongs_to :campaign, null: false, foreign_key: true
      t.string :name
      t.string :type
      t.jsonb :data, default:  {}

      t.timestamps
    end
  end
end
