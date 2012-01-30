class AddBankedPointsToBuildIterations < ActiveRecord::Migration
  def self.up
    add_column :build_iterations, :banked_points, :integer
  end

  def self.down
    remove_column :build_iterations, :banked_points
  end
end
