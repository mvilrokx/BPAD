class AddPlanningColsToBuildIterations < ActiveRecord::Migration
  def self.up
    add_column :build_iterations, :resource_count, :decimal, :precision=>12, :scale=>6
    add_column :build_iterations, :point_capacity, :decimal, :precision=>12, :scale=>6
    add_column :build_iterations, :post_planning_capacity, :decimal, :precision=>12, :scale=>6
  end

  def self.down
    remove_column :build_iterations, :resource_count
    remove_column :build_iterations, :point_capacity
    remove_column :build_iterations, :post_planning_capacity
  end
end

 
