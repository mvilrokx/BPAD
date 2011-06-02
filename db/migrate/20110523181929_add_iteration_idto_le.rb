class AddIterationIdtoLe < ActiveRecord::Migration
  def self.up
    add_column :logical_entities, :iteration_id, :integer
  end

  def self.down
    remove_column :logical_entities, :iteration_id
  end
end
