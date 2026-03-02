class CampaignInvitesController < ApplicationController
  before_action :set_campaign
  before_action :set_invite, only: %i[ update destroy ]

  def new
      @invite = CampaignInvite.new
      @pending_invites = @campaign.pending_invites
      @friends = @campaign.game_master.friends.select { |f| !@pending_invites.map(&:user_id).include?(f) }
  end

  def create
    if params[:user_ids].present?
      params[:user_ids].each do |user_id|
        invite =  @campaign.campaign_invites.new(user_id: user_id, status: "pending")
        invite.save
      end
    end
    redirect_to @campaign, notice: "Invites sent!"
  end

  def update
    if @invite.update(invite_params)
      redirect_to root_path, notice: "Invite updated."
    else
       redirect_to root_path, alert: "Could not update invite."
    end
  end

  def destroy
    @invite.destroy
    redirect_to campaign_campaign_invites_path(@campaign), alert: "Invite deleted."
  end

  private

  def set_campaign
    @campaign = Campaign.find(params[:campaign_id])
  end

  def set_invite
    @invite = CampaignInvite.find(params[:id])
  end

  def invite_params
    params.expect(campaign_invite: [ :status ])
  end
end
