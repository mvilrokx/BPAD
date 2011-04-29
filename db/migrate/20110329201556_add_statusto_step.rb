class AddStatustoStep < ActiveRecord::Migration
  def self.up
    add_column :steps, :status, :string
  end

  def self.down
    remove_column :steps, :status
  end
end
