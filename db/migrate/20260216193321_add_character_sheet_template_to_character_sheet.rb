class AddCharacterSheetTemplateToCharacterSheet < ActiveRecord::Migration[8.1]
  def change
    add_reference :character_sheets, :character_sheet_template, null: false, foreign_key: true
  end
end
