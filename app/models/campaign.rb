class Campaign < ApplicationRecord
    has_and_belongs_to_many :users
    has_many :locations, dependent: :destroy
    has_many :player_characters, dependent: :destroy
end
