class NonPlayerCharacter < ApplicationRecord
  belongs_to :campaign
  has_and_belongs_to_many :locations

  has_rich_text :description
  has_rich_text :notes
  has_one_attached :featured_image
end
