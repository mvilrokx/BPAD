class AddStepIdToBamToFamFeatures < ActiveRecord::Migration
  def self.up
    add_column :bam_to_fam_features, :step_id, :integer
  end

  def self.down
    remove_column :bam_to_fam_features, :step_id
  end
end
