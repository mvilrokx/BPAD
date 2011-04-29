class CreateFeatures < ActiveRecord::Migration
  def self.up
    create_table :features do |t|
      t.integer :functional_work_unit_id
      t.string :name
      t.text :description
      t.timestamps
    end
  end

  def self.down
    drop_table :features
  end
end
