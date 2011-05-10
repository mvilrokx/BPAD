class CreateBuildFeatures < ActiveRecord::Migration
  def self.up
    create_table :build_features do |t|
      t.string :name
      t.integer :buildable_id
      t.string :buildable_type
      t.text :description
      t.integer :iteration_id
      t.timestamps
    end
  end

  def self.down
    drop_table :build_features
  end
end
