class ChangeDataTypeonApprovalDate < ActiveRecord::Migration
  def self.up
  	change_table :approvals do |t|
      t.change :approval_date, :datetime
    end
  end

  def self.down
  	change_table :approvals do |t|
      t.change :approval_date, :date
    end
  end
end
