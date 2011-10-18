class AfAgilefantRevision < ActiveRecord::Base
  establish_connection :agilefant
  set_table_name "agilefant_revisions"
	acts_as_reportable

  REVISION_TYPES = {:create => 0,
                    :update => 1,
                    :delete => 2}

  has_many :backlog_auds, :class_name => "AfBacklogAud", :foreign_key => "REV"
  has_many :story_auds, :class_name => "AfStoryAud", :foreign_key => "REV"
	has_many :task_auds, :class_name => "AfTaskAud", :foreign_key => "REV"

	def getRevTimeHash(rev_array)
		data = AfAgilefantRevision.find(:all, :select=>"id, timestamp", :conditions => ["id IN (?)", rev_array])
		rev_timestamp_hash = Hash.new
		data.each do |r|
			rev_timestamp_hash[r.id] = r.timestamp
		end
		return rev_timestamp_hash
	end


end

