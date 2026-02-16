class Campaign < ApplicationRecord
    has_and_belongs_to_many :users
    belongs_to :user

    has_rich_text :description
    has_rich_text :notes
    has_one_attached :featured_image

    has_many :locations, dependent: :destroy
    has_many :player_characters, dependent: :destroy
    has_many :non_player_characters, dependent: :destroy
    has_one :character_sheet_template, dependent: :destroy
end
