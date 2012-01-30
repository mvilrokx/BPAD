class CreateLogicalEntities < ActiveRecord::Migration
  def self.up
    create_table :logical_entities do |t|
      t.string :name
      t.string :description
      t.integer :lbo_id
      t.boolean :datedness
      t.boolean :translation
      t.timestamps
    end
  end

  def self.down
    drop_table :logical_entities
  end
end

