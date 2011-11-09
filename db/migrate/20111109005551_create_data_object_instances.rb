class CreateDataObjectInstances < ActiveRecord::Migration
  def self.up
    create_table :data_object_instances do |t|
      t.string :name
      t.integer :step_id
      t.integer :business_process_element_id
      t.integer :iteration_id

      t.timestamps
    end
  end

  def self.down
    drop_table :data_object_instances
  end
end
