class AfTaskAud < ActiveRecord::Base
  establish_connection :agilefant
  set_table_name "tasks_AUD"
	acts_as_reportable

  belongs_to :agilefant_revision, :class_name => "AfAgilefantRevision", :foreign_key => "REV"

		def getTaskAudDataHash(task_id_array)
		data = AfTaskAud.find(:all, :select=>"id, REV, effortleft, originalestimate", :conditions => ["id IN (?)", task_id_array])
		task_aud_data_hash = Hash.new
		rev_col_array = Array.new
		data.each do |r|
			task_id = r.id
			el = r.effortleft
			os = r.originalestimate
			rev = r.REV
			if((!(el.nil?)) && (!(os.nil?)))
				rev_col_array << rev
				if(task_aud_data_hash[task_id].nil?)
					data_table = Table("REV","effortleft", "originalestimate") { |t| t << [rev, el, os]}
					task_aud_data_hash[task_id] = data_table
				else
					data_table = task_aud_data_hash[task_id]
					data_table << [rev, el, os]
					task_aud_data_hash[task_id] = data_table
				end  
			end  
		end
		rlt = Array.new
		rlt << task_aud_data_hash
		rlt << rev_col_array
		return rlt
	end

end

