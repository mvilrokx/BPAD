class AddXmlIdToBusinessProcessElement < ActiveRecord::Migration
  def self.up
  	add_column :business_process_elements, :xml_element_id, :string
  	add_column :flows, :xml_element_id, :string
  end

  def self.down
  	remove_column :business_process_elements, :xml_element_id
  	remove_column :flows, :xml_element_id
  end
end
