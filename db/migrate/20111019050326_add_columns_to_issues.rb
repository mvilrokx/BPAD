class AddColumnsToIssues < ActiveRecord::Migration
  def self.up
    add_column :issues, :severity, :string
    add_column :issues, :user_id, :integer
    add_column :issues, :issue_type, :string
    add_column :issues, :bug_number, :integer
  end

  def self.down
    remove_column :issues, :severity
    remove_column :issues, :user_id
    remove_column :issues, :issue_type
    remove_column :issues, :bug_number
  end
end

