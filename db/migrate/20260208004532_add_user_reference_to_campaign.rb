class AddUserReferenceToCampaign < ActiveRecord::Migration[8.1]
  def change
    add_reference :campaigns, :user, foreign_key: true
  end
end
