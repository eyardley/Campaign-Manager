class FriendshipsController < ApplicationController
  before_action :set_user

  def new
      @friendship = Friendship.new
  end

  def create
  end

  def update
  end

  private

  def set_user
    @user = User.find(params[:user_id])
  end

end
