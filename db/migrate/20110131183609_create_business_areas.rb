class CreateBusinessAreas < ActiveRecord::Migration
  def self.up
    create_table :business_areas do |t|
      t.string :name
      t.integer :parent_id
      t.timestamps
    end
  end

  def self.down
    drop_table :business_areas
  end
end
