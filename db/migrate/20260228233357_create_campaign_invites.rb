class CreateCampaignInvites < ActiveRecord::Migration[8.1]
  def change
    create_table :campaign_invites do |t|
      t.belongs_to :campaign, null: false, foreign_key: true
      t.belongs_to :user, null: false, foreign_key: true
      t.string :status

      t.timestamps
    end
  end
end
