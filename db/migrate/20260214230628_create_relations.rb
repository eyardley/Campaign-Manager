class CreateRelations < ActiveRecord::Migration[8.1]
  def change
    create_table :relations do |t|
      t.references :source, polymorphic: true, null: false
      t.references :target, polymorphic: true, null: false
      t.timestamps
    end

    add_index :relations, [:source_type, :source_id, :target_type, :target_id],
              unique: true, name: "index_relations_uniqueness"
  end
end
