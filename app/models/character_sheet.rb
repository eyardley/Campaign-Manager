class CharacterSheet < ApplicationRecord
  belongs_to :player_character
  belongs_to :character_sheet_template
end
