class CampaignInvite < ApplicationRecord
  belongs_to :campaign
  belongs_to :user

  after_update :associate_user_with_campaign, if: :accepted?

  private

  def accepted?
    saved_change_to_status?(to: "accepted")
  end

  def associate_user_with_campaign
    campaign.users << user unless campaign.users.include?(user)
  end
end
