class RenameUserIdToGameMasterIdOnCampaigns < ActiveRecord::Migration[8.1]
  def change
    rename_column :campaigns, :user_id, :game_master_id
  end
end
