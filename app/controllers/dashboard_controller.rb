class DashboardController < ApplicationController

  def index
    @campaigns = Current.user.campaigns
    @pcs = Current.user.player_characters
    @friendships = Current.user.accepted_friendships
    @friend_requests = Current.user.friend_requests
  end
end
