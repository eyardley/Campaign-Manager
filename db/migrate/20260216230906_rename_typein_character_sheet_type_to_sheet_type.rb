class RenameTypeinCharacterSheetTypeToSheetType < ActiveRecord::Migration[8.1]
  def change
     rename_column :character_sheet_templates, :type, :sheet_type
  end
end
