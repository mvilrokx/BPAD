class AddFragmentTable < ActiveRecord::Migration
  def self.up
   create_table :fragments do |t|
      t.integer :allocated
      t.integer :build_iteration_id 
      t.integer :path_id
      t.decimal :points
      t.integer :user_id 
      t.decimal :hours_equivalent 
    end  
  end

  def self.down
    drop_table :fragments
  end
end


