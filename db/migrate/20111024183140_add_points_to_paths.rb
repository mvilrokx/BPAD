class AddPointsToPaths < ActiveRecord::Migration
  def self.up
    add_column :paths, :points, :integer
  end

  def self.down
    remove_column :paths, :points
  end
end

