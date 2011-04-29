class AddStateToIteration < ActiveRecord::Migration
  def self.up
    add_column :iterations, :status, :string
  end

  def self.down
    remove_column :iterations, :status
  end
end
