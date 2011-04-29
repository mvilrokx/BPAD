class AddIterationIdtoMaps < ActiveRecord::Migration
  def self.up
    add_column :bam_to_fam_maps, 			 :iteration_id,    :integer
  end

  def self.down
    remove_column :bam_to_fam_maps,    :iteration_id
  end
end
