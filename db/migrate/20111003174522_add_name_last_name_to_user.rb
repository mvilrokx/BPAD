class AddNameLastNameToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :name, :string
    add_column :users, :last_name, :string
  end

  def self.down
    remove_column :users, :last_name
    remove_column :users, :name
  end
end
