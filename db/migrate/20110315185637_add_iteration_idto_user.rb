class AddIterationIdtoUser < ActiveRecord::Migration
  def self.up
    add_column :users, :iteration_id,    :integer
  end

  def self.down
    remove_column :users, :iteration_id
  end
end
