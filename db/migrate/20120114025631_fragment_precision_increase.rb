class FragmentPrecisionIncrease < ActiveRecord::Migration
  def self.up
     change_column :fragments, :points, :decimal, {:precision => 10, :scale => 6}
     change_column :fragments, :hours_equivalent, :decimal, {:precision => 10, :scale => 6}
  end

  def self.down
     change_column :fragments, :points, :decimal, {:precision => 10, :scale => 0}
     change_column :fragments, :hours_equivalent, :decimal, {:precision => 10, :scale => 0}
  end
end

 
 
