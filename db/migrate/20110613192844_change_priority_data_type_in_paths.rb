class ChangePriorityDataTypeInPaths < ActiveRecord::Migration
  def self.up
	change_column :paths, :priority, :integer
  end

  def self.down
	change_column :paths, :priority, :string
  end
end
