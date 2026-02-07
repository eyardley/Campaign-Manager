class Location < ApplicationRecord
  belongs_to :campaign
  has_and_belongs_to_many :non_player_characters
  has_rich_text :description
  has_rich_text :notes
  has_one_attached :featured_image
  validates :name, presence: true

end
