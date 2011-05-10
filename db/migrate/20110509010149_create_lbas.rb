class CreateLbas < ActiveRecord::Migration
  def self.up
    create_table :lbas do |t|
      t.string :name
      t.integer :parent_id
      t.integer :iteration_id
      t.timestamps
    end
  end

  def self.down
    drop_table :lbas
  end
end
