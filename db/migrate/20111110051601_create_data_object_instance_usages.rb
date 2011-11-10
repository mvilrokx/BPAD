class CreateDataObjectInstanceUsages < ActiveRecord::Migration
  def self.up
    create_table :data_object_instance_usages do |t|
      t.integer :step_id
      t.integer :data_object_instance_id
      t.integer :business_process_element_id
      t.integer :iteration_id

      t.timestamps
    end
  end

  def self.down
    drop_table :data_object_instance_usages
  end
end

