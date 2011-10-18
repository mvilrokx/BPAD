class AfTask < ActiveRecord::Base
  establish_connection :agilefant
  set_table_name "tasks"
	acts_as_reportable

  belongs_to :story, :class_name => "AfStory", :foreign_key => "story_id"
  has_many :task_users, :class_name => "AfTaskUser", :foreign_key => "tasks_id"
  has_many :users, :through => :task_users

  def developers
    @dev = []
    for user in users
      @dev << user.fullName
    end
    @dev
  end

	def getStoryTaskHash(story_array)
		data = AfTask.find(:all, :select=>"id, story_id", :conditions => ["story_id IN (?)", story_array])
		story_task_hash = Hash.new
		task_id_array = Array.new
		data.each do |r|
			story_id = r.story_id 
			task_id = r.id 
			task_id_array << task_id
			if(story_task_hash[story_id].nil?)
				task_array = Array.new
				task_array << task_id 
				story_task_hash[story_id] = task_array
			else
				task_array = story_task_hash[story_id]
				if(!task_array.include?(task_id))						
					task_array << task_id 
					story_task_hash[story_id] = task_array
				end
			end
		end
		rlt = Array.new
		rlt << story_task_hash 
		rlt << task_id_array
		return rlt
	end



end

