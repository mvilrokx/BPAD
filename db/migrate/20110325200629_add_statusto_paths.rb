class AddStatustoPaths < ActiveRecord::Migration
  def self.up
    add_column :paths, :status, :string
  end

  def self.down
    remove_column :paths, :status
  end
end
