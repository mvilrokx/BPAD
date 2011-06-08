class AddDescriptionToLbo < ActiveRecord::Migration
  def self.up
    add_column :lbos, :description, :string
  end

  def self.down
    remove_column :lbos, :description
  end
end
