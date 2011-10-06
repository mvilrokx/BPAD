class AfStoryAud < ActiveRecord::Base
  establish_connection :agilefant
  set_table_name "stories_AUD"
	acts_as_reportable

  belongs_to :agilefant_revision, :class_name => "AfAgilefantRevision", :foreign_key => "REV"
	belongs_to :backlog, :class_name => "AfBacklog", :foreign_key => "backlog_id"

end

