class AddPlanningTable < ActiveRecord::Migration
  def self.up
   create_table :planning_runs do |t|
      t.decimal :ppdi, :precision=>10, :scale=>10
      t.integer :number_its_used
      t.integer :number_paths_planned
      t.decimal :iteration_capacity_used, :precision=>10, :scale=>10
      t.decimal :points_of_planned_paths, :precision=>10, :scale=>10
      t.integer :planned_months_in_agilefant 
      t.text    :messages
    end  
  end

  def self.down
    drop_table :planning_runs
  end
end
