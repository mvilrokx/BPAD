class CreateWatchings < ActiveRecord::Migration
  def self.up
    create_table :watchings do |t|
      t.integer :user_id
      t.integer :watchable_id
      t.string :watchable_type
      t.boolean :creator
      t.timestamps
    end
  end

  def self.down
    drop_table :watchings
  end
end
