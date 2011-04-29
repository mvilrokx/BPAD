class CreateBusinessProcessElements < ActiveRecord::Migration
  def self.up
    create_table :business_process_elements do |t|
      t.integer :business_process_id
      t.string :name
      t.string :element_type
      t.timestamps
    end
  end

  def self.down
    drop_table :business_process_elements
  end
end
