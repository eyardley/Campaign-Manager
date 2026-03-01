class CharacterSheetTemplate < ApplicationRecord
  belongs_to :campaign
  has_many :character_sheets, dependent: :destroy

  def to_character_sheet()
    self.data.transform_values { |value| { type: value, value: '' } }
  end
end
