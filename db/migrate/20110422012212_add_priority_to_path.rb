class AddPriorityToPath < ActiveRecord::Migration
  def self.up
    add_column :paths, :priority, :string
    add_column :business_processes, :priority, :string
  end

  def self.down
    remove_column :paths, :priority
    remove_column :business_processes, :priority
  end
end
