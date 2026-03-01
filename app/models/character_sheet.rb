class CharacterSheet < ApplicationRecord
  belongs_to :player_character
  belongs_to :character_sheet_template

  def sync_with_template
    template = CharacterSheetTemplate.find(self.character_sheet_template_id)

    fields_to_remove = self.data.keys - template.data.keys
    fields_to_remove.each { |field| self.data.delete(field) }

    fields_to_add = template.data.keys - self.data.keys
    fields_to_add.each { |field| self.data[field] = { "type": template.data[field], "value": "" } }
  end
end
