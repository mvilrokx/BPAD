class AddPlanningFieldsToPath < ActiveRecord::Migration
  def self.up
    add_column :paths, :calc_start_it, :date
    add_column :paths, :calc_stop_it, :date
    add_column :paths, :max_developers, :integer
  end

  def self.down
    remove_column :paths, :calc_start_it
    remove_column :paths, :calc_stop_it
    remove_column :paths, :max_developers
  end
end
