class CreateInterfaces < ActiveRecord::Migration
  def self.up
    create_table :interfaces do |t|
      t.string :name
      t.string :description
      t.integer :lba_id
      t.integer :iteration_id
      t.timestamps
    end
  end

  def self.down
    drop_table :interfaces
  end
end
