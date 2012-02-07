class AddPlanFlagToBusinessProcess < ActiveRecord::Migration
  def self.up
    add_column :business_processes, :include_in_plan, :boolean
  end

  def self.down
    remove_column :business_processes, :include_in_plan
  end
end
