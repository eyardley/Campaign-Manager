class CreateLocations < ActiveRecord::Migration[8.1]
  def change
    create_table :locations do |t|
      t.belongs_to :campaign, null: false, foreign_key: true
      t.string :name

      t.timestamps
    end
  end
end
