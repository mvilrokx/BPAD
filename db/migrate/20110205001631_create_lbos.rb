class CreateLbos < ActiveRecord::Migration
  def self.up
    create_table :lbos do |t|
      t.integer :business_area_id
      t.string :name
      t.timestamps
    end
  end

  def self.down
    drop_table :lbos
  end
end
