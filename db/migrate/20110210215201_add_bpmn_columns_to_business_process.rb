class AddBpmnColumnsToBusinessProcess < ActiveRecord::Migration
  def self.up
    add_column :business_processes, :bpmn_file_name,    :string
    add_column :business_processes, :bpmn_content_type, :string
    add_column :business_processes, :bpmn_file_size,    :integer
    add_column :business_processes, :bpmn_updated_at,   :datetime
  end

  def self.down
    remove_column :business_processes, :bpmn_file_name
    remove_column :business_processes, :bpmn_content_type
    remove_column :business_processes, :bpmn_file_size
    remove_column :business_processes, :bpmn_updated_at
  end
end
