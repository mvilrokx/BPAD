class CreateFunctionalWorkUnits < ActiveRecord::Migration
  def self.up
    create_table :functional_work_units do |t|
      t.string :name
      t.string :type
      t.integer :business_area_id
      t.integer :parent_id
      t.timestamps
    end
  end

  def self.down
    drop_table :functional_work_units
  end
end
