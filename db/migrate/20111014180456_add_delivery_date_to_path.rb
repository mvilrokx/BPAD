class AddDeliveryDateToPath < ActiveRecord::Migration
  def self.up
    add_column :paths, :estimated_delivery_date, :date
  end

  def self.down
    remove_column :paths, :estimated_delivery_date
  end
end

