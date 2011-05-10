class AddParentIdToBuildFeature < ActiveRecord::Migration
  def self.up
    add_column :build_features, :parent_id, :integer
  end

  def self.down
    remove_column :build_features, :parent_id
  end
end
