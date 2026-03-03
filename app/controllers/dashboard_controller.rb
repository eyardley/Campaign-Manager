class DashboardController < ApplicationController
  def index
    @campaigns = Current.user.campaigns
    #@pcs = Current.user.player_characters
    @friendships = Current.user.accepted_friendships
    @friend_requests = Current.user.friend_requests
    @campaign_invites = Current.user.pending_campaign_invites
  end
end
