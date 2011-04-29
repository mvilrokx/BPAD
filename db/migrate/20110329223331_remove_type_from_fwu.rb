class RemoveTypeFromFwu < ActiveRecord::Migration
  def self.up
  	remove_column :functional_work_units, :type
  end

  def self.down
  	add_column :functional_work_units, :type, :string
  end
end
