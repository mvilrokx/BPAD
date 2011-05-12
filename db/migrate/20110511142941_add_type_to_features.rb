class AddTypeToFeatures < ActiveRecord::Migration
  def self.up
    add_column :features, :feature_type, :string
  end

  def self.down
    remove_column :features, :feature_type
  end
end
