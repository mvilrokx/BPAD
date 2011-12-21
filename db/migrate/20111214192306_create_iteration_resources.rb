class CreateIterationResources < ActiveRecord::Migration
  def self.up
    create_table :iteration_resources do |t|
      t.integer :build_iteration_id
      t.integer :user_id
      t.integer :resource_pct

      t.timestamps
    end
  end

  def self.down
    drop_table :iteration_resources
  end
end
