class CreateBamToFamMaps < ActiveRecord::Migration
  def self.up
    create_table :bam_to_fam_maps do |t|
      t.integer :step_id
      t.integer :functional_work_unit_id
      t.string :status
      t.timestamps
    end
  end

  def self.down
    drop_table :bam_to_fam_maps
  end
end
