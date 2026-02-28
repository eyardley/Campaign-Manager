class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  normalizes :email_address, with: ->(e) { e.strip.downcase }

  has_and_belongs_to_many :campaigns
  has_many :friendships, dependent: :destroy
  has_many :player_characters, dependent: :destroy

  def friend_records()
    Friendship.where(user: self).or(Friendship.where(friend: self))
  end

  def accepted_friendships()
      friend_records.where(status: "accepted").includes(:user, :friend)
  end

  def friend_requests()
    Friendship.where(friend: self, status: "pending")
  end
end
