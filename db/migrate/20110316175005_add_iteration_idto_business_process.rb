class AddIterationIdtoBusinessProcess < ActiveRecord::Migration
  def self.up
    add_column :business_processes, 			 :iteration_id,    :integer
    add_column :business_process_elements, :iteration_id,    :integer
    add_column :flows,									   :iteration_id,    :integer
    add_column :business_areas, 					 :iteration_id,    :integer
    add_column :features, 								 :iteration_id,    :integer
    add_column :lbos,											 :iteration_id,    :integer
    add_column :paths,										 :iteration_id,    :integer
    add_column :steps,										 :iteration_id,    :integer
    add_column :functional_work_units,		 :iteration_id,    :integer
  end

  def self.down
    remove_column :business_processes, 				:iteration_id
    remove_column :business_process_elements, :iteration_id
    remove_column :flows,									    :iteration_id
    remove_column :business_areas, 					   :iteration_id
    remove_column :features, 								  :iteration_id
    remove_column :lbos,										  :iteration_id
    remove_column :paths,										  :iteration_id
    remove_column :steps,										  :iteration_id
    remove_column :functional_work_units,		  :iteration_id
  end
end
