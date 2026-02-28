class Friendship < ApplicationRecord
  belongs_to :user
  belongs_to :friend, class_name: "User"

  validate :no_reverse_friendship, on: :create

  private

  def no_reverse_friendship
    if Friendship.where(user: friend, friend: user).exists?
      errors.add(:base, "A friendship with this user already exists")
    end
  end
end
