class CharacterSheetTemplate < ApplicationRecord
  belongs_to :campaign
  belongs_to :character_sheet
end
