class AddFieldsToFeature < ActiveRecord::Migration
  def self.up
  	add_column :features, :priority, :string
  	add_column :features, :scope, :string
  end

  def self.down
  	remove_column :features, :priority
  	remove_column :features, :scope
  end
end
