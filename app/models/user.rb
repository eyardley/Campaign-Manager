class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy

  has_and_belongs_to_many :campaigns
  has_many :player_characters, dependent: :destroy

  normalizes :email_address, with: ->(e) { e.strip.downcase }
end
