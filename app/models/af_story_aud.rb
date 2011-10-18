class AfStoryAud < ActiveRecord::Base
  establish_connection :agilefant
  set_table_name "stories_AUD"
	acts_as_reportable

  belongs_to :agilefant_revision, :class_name => "AfAgilefantRevision", :foreign_key => "REV"
	belongs_to :backlog, :class_name => "AfBacklog", :foreign_key => "backlog_id"

	def getStoryIdBacklogdIdMap(id_array)
		data = AfStoryAud.find(:all, :select=>"id, backlog_id", :conditions => ["stories_AUD.id IN (?)", id_array])
		story_id_backlog_id_hash = Hash.new
		data.each do |r|
			story_id = r.id
			backlog_id = r.backlog_id
			if(story_id_backlog_id_hash[story_id].nil?)
				backlog_array = Array.new
				backlog_array << backlog_id
				story_id_backlog_id_hash[story_id] = backlog_array
			else
				backlog_array = story_id_backlog_id_hash[story_id]
				if(!backlog_array.include?(backlog_id))
					backlog_array << backlog_id
					story_id_backlog_id_hash[story_id] = backlog_array
				end
			end
		end
		return story_id_backlog_id_hash
	end

end

