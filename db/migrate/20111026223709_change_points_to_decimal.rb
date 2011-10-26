class ChangePointsToDecimal < ActiveRecord::Migration
  def self.up
    change_column :paths, :points, :decimal, {:precision => 10, :scale => 2}
  end

  def self.down
    change_column :paths, :points, :integer
  end
end

