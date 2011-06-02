class CreateLogicalEntityAttributes < ActiveRecord::Migration
  def self.up
    create_table :logical_entity_attributes do |t|
      t.string :name
      t.boolean :mandatory
      t.string :le_type
      t.integer :logical_entity_id
      t.integer :iteration_id
      t.timestamps
    end
  end

  def self.down
    drop_table :logical_entity_attributes
  end
end
