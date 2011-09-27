class AddEstimateToPath < ActiveRecord::Migration
  def self.up
    add_column :paths, :estimate, :integer
  end

  def self.down
    remove_column :paths, :estimate
  end
end
