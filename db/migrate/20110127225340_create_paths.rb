class CreatePaths < ActiveRecord::Migration
  def self.up
    create_table :paths do |t|
      t.integer :business_process_id
      t.string :name
      t.text :description
      t.timestamps
    end
  end

  def self.down
    drop_table :paths
  end
end
