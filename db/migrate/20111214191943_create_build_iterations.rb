class CreateBuildIterations < ActiveRecord::Migration
  def self.up
    create_table :build_iterations do |t|
      t.date :start_date
      t.date :stop_date

      t.timestamps
    end
  end

  def self.down
    drop_table :build_iterations
  end
end
