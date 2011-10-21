class AfStoryAud < ActiveRecord::Base
  establish_connection :agilefant
  set_table_name "stories_AUD"

  belongs_to :agilefant_revision, :class_name => "AfAgilefantRevision", :foreign_key => "REV"
	belongs_to :backlog, :class_name => "AfBacklog", :foreign_key => "backlog_id"

	def getStoryIdBacklogIdMap(id_array)
		data = AfStoryAud.find(:all, :select=>"id, REV, backlog_id", :conditions => ["id IN (?)", id_array])
		rev_array = Array.new 
		iter_array = Array.new  
		story_array = Array.new 
		data.each do |r|
			rev_array << r.REV 
			iter_id = r.backlog_id
			if(!iter_array.include?(iter_id))
				iter_array << iter_id
			end 
			story_id = r.id 
			if(!story_array.include?(story_id))
				story_array << story_id
			end 
		end 
		afAgilefantRevision = AfAgilefantRevision.new 
		rev_timestamp_hash = afAgilefantRevision.getRevTimeHash(rev_array)
		
		temp_hash = Hash.new 
		data.each do |r|
			story_id = r.id 
			iter_id = r.backlog_id 
			timestamp = rev_timestamp_hash[r.REV]
			timepoint = Time.at(timestamp/1000).to_date
			if(temp_hash[story_id].nil?)
				iter_hash = Hash.new 
				timepoint_array = Array.new 
				timepoint_array << timepoint
				iter_hash[iter_id] = timepoint_array
				temp_hash[story_id] = iter_hash 
			else
				iter_hash = temp_hash[story_id]
				if(iter_hash[iter_id].nil?)
					timepoint_array = Array.new 
					timepoint_array << timepoint
					iter_hash[iter_id] = timepoint_array
				else
					timepoint_array = iter_hash[iter_id] 
					timepoint_array << timepoint
					iter_hash[iter_id] = timepoint_array
				end #(iter_hash[iter_id].nil?)
				temp_hash[story_id] = iter_hash 
			end #if(temp_hash[story_id].nil?)
		end #data.each do |r|
		story_id_backlog_id_hash = consolidateIterationForStory(temp_hash, iter_array, story_array)
		return story_id_backlog_id_hash
	end 

protected

	def consolidateIterationForStory(data, iter_array, story_array)
		afBacklog = AfBacklog.new 
		iter_start_date_hash = afBacklog.getPartIterationIdStartdateMap(iter_array)
		afStory = AfStory.new 
		current_story_iter_hash = afStory.getCurrentStoryIdBacklogIdMap(story_array)
		rlt = Hash.new 
		data.each do |story_id, iter_hash|
			iter_array = Array.new 	
				iter_hash.each do |iter_id, timepoint_array|
						timepoint_array.sort!						
						cnt = 1
						while(!timepoint_array[cnt].nil?)
							previous_timepoint = timepoint_array[cnt-1]
							if((timepoint_array[cnt]-previous_timepoint).abs > 2)
								iter_array << iter_id
								cnt = timepoint_array.length
							else
								cnt += 1
							end 
						end 						
				end #iter_hash.each do |iter_id, timepoint_array|		
				current_iter = current_story_iter_hash[story_id]
				if(!iter_array.include?(current_iter))
					iter_array << current_iter
				end 		
			rlt[story_id] = iter_array
		end #data.each do |story_id, iter_hash|
		return rlt
	end 

end

