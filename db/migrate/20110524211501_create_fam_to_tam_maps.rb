class CreateFamToTamMaps < ActiveRecord::Migration
  def self.up
    create_table :fam_to_tam_maps do |t|
      t.integer :feature_id
      t.integer :build_feature_id
      t.integer :iteration_id
      t.timestamps
    end
  end

  def self.down
    drop_table :fam_to_tam_maps
  end
end
