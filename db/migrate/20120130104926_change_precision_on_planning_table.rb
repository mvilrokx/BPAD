class ChangePrecisionOnPlanningTable < ActiveRecord::Migration
  def self.up
     change_column :planning_runs, :ppdi, :decimal, {:precision => 10, :scale => 6}
     change_column :planning_runs, :iteration_capacity_used, :decimal, {:precision => 10, :scale => 6}
     change_column :planning_runs, :points_of_planned_paths, :decimal, {:precision => 10, :scale => 6}
  end

  def self.down
     change_column :planning_runs, :ppdi, :decimal, {:precision => 10, :scale => 10}
     change_column :planning_runs, :iteration_capacity_used, :decimal, {:precision => 10, :scale => 10}
     change_column :planning_runs, :points_of_planned_paths, :decimal, {:precision => 10, :scale => 10}
  end
end
