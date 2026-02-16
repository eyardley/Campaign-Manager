class PlayerCharacter < ApplicationRecord
  belongs_to :campaign
  belongs_to :user
  has_one :character_sheet, dependent: :destroy

  has_rich_text :description
  has_rich_text :notes
  has_one_attached :featured_image
end
