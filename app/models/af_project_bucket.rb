class AfProjectBucket < ActiveRecord::Base
#	has_many :stories, :class_name => "AfStory", :foreign_key => "proj_id"
	belongs_to :backlog, :class_name => "AfBacklog", :foreign_key => "proj_id"

  establish_connection :agilefant
  set_table_name "project_buckets"

  def left_over_hours
    bucket_hours - backlog.original_estimate/60
  end
end

