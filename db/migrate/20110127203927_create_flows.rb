class CreateFlows < ActiveRecord::Migration
  def self.up
    create_table :flows do |t|
      t.integer :business_process_element_id
      t.integer :target_element_id
      t.timestamps
    end
  end

  def self.down
    drop_table :flows
  end
end
