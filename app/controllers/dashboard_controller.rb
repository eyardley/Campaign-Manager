class DashboardController < ApplicationController

  def index
    @campaigns = Current.user.campaigns
    @pcs = Current.user.player_characters
    @friends = Current.user.friends
    @friend_requests = Current.user.friend_requests
  end
end
