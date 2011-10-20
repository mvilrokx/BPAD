class AddSourceToIssues < ActiveRecord::Migration
  def self.up
    add_column :issues, :source, :string
  end

  def self.down
    remove_column :issues, :source
  end
end

