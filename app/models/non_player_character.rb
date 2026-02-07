class NonPlayerCharacter < ApplicationRecord
  belongs_to :campaign
  has_and_belongs_to_many :locations
end
