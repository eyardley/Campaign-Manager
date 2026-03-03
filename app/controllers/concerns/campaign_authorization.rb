module CampaignAuthorization
  extend ActiveSupport::Concern

  private

  def set_is_game_master
    @is_game_master = @campaign.game_master_id == Current.user.id
  end

  def require_game_master
    redirect_to campaigns_path unless @campaign.game_master_id == Current.user.id
  end

  def require_user_belongs_to_campaign
    redirect_to root_path unless @campaign.users.include?(Current.user)
  end
end
