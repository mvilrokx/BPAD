class CreateWorkAssignments < ActiveRecord::Migration
  def self.up
    create_table :work_assignments do |t|
      t.integer :user_id
      t.integer :path_id
      t.timestamps
    end
  end

  def self.down
    drop_table :work_assignments
  end
end

