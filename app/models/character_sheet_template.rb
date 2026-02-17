class CharacterSheetTemplate < ApplicationRecord
  belongs_to :campaign
  has_many :character_sheets, dependent: :destroy
end
