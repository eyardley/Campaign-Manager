class CharacterSheet < ApplicationRecord
  belongs_to :player
  has_one :character_sheet_template
end
