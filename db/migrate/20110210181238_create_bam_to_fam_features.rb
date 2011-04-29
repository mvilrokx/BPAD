class CreateBamToFamFeatures < ActiveRecord::Migration
  def self.up
    create_table :bam_to_fam_features do |t|
      t.integer :feature_id
      t.integer :bam_to_fam_map_id
      t.timestamps
    end
  end

  def self.down
    drop_table :bam_to_fam_features
  end
end
