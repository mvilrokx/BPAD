class CreateBusinessProcesses < ActiveRecord::Migration
  def self.up
    create_table :business_processes do |t|
      t.string :name
      t.timestamps
    end
  end

  def self.down
    drop_table :business_processes
  end
end
