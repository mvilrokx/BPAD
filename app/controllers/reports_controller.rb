class ReportsController < ApplicationController
	before_filter :login_required

	$ALL_ITERATIONS = "All Iterations"
	$ALL_PROJECTS = "All Projects"
	$ALL_USECASES = "All Use Cases"
	$TASK_ID_COL = "task_id"
	$TASK_NAME_COL = "task_name"
	$STORY_ID_COL = "story_id"
	$STORY_NAME_COL = "story_name"
	$USECASE_ID_COL = "usecase_id"
	$ITERATION_COL = "iteration"
	$STARTDATE_COL = "startDate"
	$ENDDATE_COL = "endDate"
	$BUSINESS_PROCESS_COL = "businessProcess"
	$EFFORT_LEFT_COL = "effortleft"
	$ORIGINAL_ESTIMATE_COL = "originalestimate"
	$TIME_STAMP_COL = "timestamp"

	$g_dates = Array.new
	$g_effortleft = Array.new
	$g_effortestimate = Array.new

	$current_date = Date.today
	
	def index

	story_data = AfStory.report_table(:all, :only=>[:id, :name, :parent_id], :include => {:backlog =>{:only=>[:name, :startDate, :endDate, :backlogtype], :include =>{:businessProcess => {:only=>[:name]}}}})
	story_data.rename_column("id", "story_id")
	story_data.rename_column("name", "story_name")
	story_data.rename_column("parent_id", "usecase_id")
	story_data.rename_column("backlog.name","iteration")
	story_data.rename_column("backlog.startDate","startDate")
	story_data.rename_column("backlog.endDate","endDate")
	story_data.rename_column("backlog.backlogtype","backlogtype")
	story_data.rename_column("businessProcess.name","businessProcess")
	story_data.sub_table!{ |r| (r.backlogtype).eql?("Iteration")}
	$all_story_data = story_data	

	$end_date_all_iterations = Date.new((Date.today>>3).year,(Date.today>>3).month,1)-1

	afStory = AfStory.new
	$usecase_id_name_map = afStory.getUsecaseNames 

	afBacklog = AfBacklog.new
	$iteration_startdate_map = afBacklog.getIterationStartdateMap
	$project_id_map = afBacklog.getProjectIdMap

	a = $all_story_data
	a.sort_rows_by!($STARTDATE_COL, :order => :descending)
	$g_iteration_order = Array.new
	iteration_col = a.column($ITERATION_COL)
	iteration_col.each do |iter|
		if(iter!=nil && !($g_iteration_order.include?(iter)))
			$g_iteration_order << iter
		end
	end	

	@iterations = $g_iteration_order
	@iterations << $ALL_ITERATIONS		

	@default_iteration = $ALL_ITERATIONS
	data = $all_story_data
	create_bpname_list(data)
	create_usecase_list(data)
	get_start_end_date_for_all_iterations
	cal_story_iteration_startDate_mapping(data)
	cal_burn_down_all_iterations
	@dates = $g_dates
	@effortestimate = $g_effortestimate
	@effortleft = $g_effortleft
	$current_iteration = @default_iteration
	
	end

	def updateChart
		 
		selects = params[:id].split('&')
		iteration = selects[0].split('=')[1].gsub('+', ' ')
		project = selects[1].split('=')[1].gsub('+', ' ')
		usecase = selects[2].split('=')[1].gsub('+', ' ')

		@dates = nil
		@effortestimate = nil
		@effortleft = nil	
		
		data = $all_story_data
			
		if(!project.eql?($ALL_PROJECTS))
			data = data.sub_table{ |r| (r.businessProcess).eql?(project)}
		end
		if(!usecase.eql?($ALL_USECASES))
			if(usecase.eql?("Code Fixes") && project.eql?($ALL_PROJECTS))
				new_data = nil
				$usecase_id_name_map.each do |id, name|
					if(name.start_with?("Code Fixes"))
						sub_data = data.sub_table{ |r| (r.usecase_id).eql?(id)}
						if(!new_data.nil?)
							new_data = new_data + sub_data
						else
							new_data = sub_data
						end
						end
					end
					data = new_data
				else
				lookup_usecase = usecase.to_s + "@"+($project_id_map.index(project)).to_s 
				data = data.sub_table{ |r| (r.usecase_id).eql?($usecase_id_name_map.index(lookup_usecase))}
			end
		end
		get_start_end_date_for_all_iterations
		cal_story_iteration_startDate_mapping(data)
		cal_burn_down_all_iterations
		if(iteration.eql?($ALL_ITERATIONS))
			@dates = $g_dates
			@effortestimate = $g_effortestimate
			@effortleft = $g_effortleft
		end
		if(!iteration.eql?($ALL_ITERATIONS))			
			iter_start_date = $iteration_startdate_map[iteration].to_date	
			cal_one_iteration_chart(iter_start_date)
			@dates = $g_one_iter_dates
			@effortestimate = $g_one_iter_effortestimate
			@effortleft = $g_one_iter_effortleft
		end
		render :partial => 'show_chart'
	end


	def iteration_change_listener
		iteration = params[:id]
		data = $all_story_data
		if(!iteration.eql?($ALL_ITERATIONS))
			data = $all_story_data.sub_table{ |r| (r.iteration).eql?(iteration)}
		end
		$current_iteration = iteration
		create_bpname_list(data)
		create_usecase_list(data)
		render :partial => 'select_project'
	end

	def project_change_listener
		project = params[:id]
		data = $all_story_data
		if(!$current_iteration.eql?($ALL_ITERATIONS)) 
			data = $all_story_data.sub_table{ |r| (r.iteration).eql?($current_iteration)}
		end
		if(!project.eql?($ALL_PROJECTS))
			data = data.sub_table{ |r| (r.businessProcess).eql?(project)}
		end
		create_usecase_list(data)
		render :partial => 'select_usecase'
	end

	private 

		def get_start_end_date_for_all_iterations
			project_data = AfBacklog.report_table(:all, :only => [:name, :startDate, :endDate], :conditions => "backlogtype like 'Project'")
			startdate = nil
			enddate = nil
			project_data.sort_rows_by!($STARTDATE_COL)
			startdate_col = project_data.column($STARTDATE_COL)
			startdate = startdate_col[0].to_date
			project_data.sort_rows_by!($ENDDATE_COL)
			enddate_col = project_data.column($ENDDATE_COL)
			enddate = enddate_col[-1].to_date
			if(enddate > $end_date_all_iterations)
				enddate = $end_date_all_iterations
			end	
			$g_startdate = startdate
			$g_enddate = enddate
		end

		def cal_story_iteration_startDate_mapping(data)
			$story_iteration_map = Hash.new
			story_id_col = data.column($STORY_ID_COL)
			story_id_col.each do |story_id|
			story_aud_data = AfStoryAud.report_table(:all, :only=>[:id], :include =>{:backlog =>{:only=>		[:name, :startDate, :endDate, :backlogtype]}}, :conditions => ["stories_AUD.id= ?", story_id])
			story_aud_data.rename_column("backlog.name",$ITERATION_COL)
			story_aud_data.rename_column("backlog.startDate",$STARTDATE_COL)	
			story_aud_data.rename_column("backlog.endDate",$ENDDATE_COL)
			story_aud_data.rename_column("backlog.backlogtype","backlogtype")
			story_aud_data = story_aud_data.sub_table{ |r| (r.backlogtype).eql?("Iteration")}

			iteration_start_date_array = Array.new			
			
			start_date_col = story_aud_data.column($STARTDATE_COL)
			start_date_col.each do |start_date|
				startdate = start_date.to_date
				enddate = (startdate >> 1) -1
				if((!iteration_start_date_array.include?(startdate)) && (enddate <= $end_date_all_iterations))
					iteration_start_date_array << startdate
				end
			end
			iteration_start_date_array.sort!
			iteration_start_date_array.reverse!		
			$story_iteration_map[story_id] = iteration_start_date_array
			end
		end

		def cal_one_iteration_chart(start_date)
			$g_one_iter_dates = Array.new
			$g_one_iter_effortleft = Array.new
			$g_one_iter_effortestimate = Array.new
			end_date = (start_date >> 1) -1
			count = end_date + 1 - start_date
			effortleft_count = count 
			if($current_date >= start_date  && $current_date <= end_date)
				effortleft_count = $current_date + 1 - start_date
			end
			if($current_date < start_date)
				effortleft_count = 0
			end
			date = start_date + 1
			baseline = $g_effortestimate[end_date - $g_startdate]
			startindex = start_date - $g_startdate - 1
			for i in (1..count)
				$g_one_iter_dates << date.to_s
				$g_one_iter_effortestimate << $g_effortestimate[startindex+i]-baseline 
				date += 1
			end
			for i in (1..effortleft_count)
				$g_one_iter_effortleft << $g_effortleft[startindex+i] - baseline
			end			
		end

		def cal_burn_down_all_iterations
			$g_dates = Array.new
			$g_effortleft = Array.new
			$g_effortestimate = Array.new
			start_date = $g_startdate.to_date
			end_date = $g_enddate.to_date
			count = end_date + 1 - start_date
			effortleft_count = count 
			if($current_date >= start_date  && $current_date <= end_date)
				effortleft_count = $current_date + 1 - start_date
			end
			if($current_date < start_date)
				effortleft_count = 0
			end
			date = start_date + 1
			for i in (1..count)
				$g_dates << date.to_s
				$g_effortestimate << 0 
				date += 1
			end
			for i in (1..effortleft_count)
				$g_effortleft << 0
			end
			$story_iteration_map.each do |story_id, iteration_array|
				task_data = AfTask.report_table(:all, :only => [:id, :story_id], :conditions => ["story_id= ? ", story_id])
				if(!(task_data.empty?))
					task_id_col = task_data.column("id")
					task_id_col.each do |task_id|
						task_aud_data = AfTaskAud.report_table(:all, :only => [:id, :effortleft, :originalestimate], :include => {:agilefant_revision => {:only => [:timestamp]}}, :conditions => ["tasks_AUD.id= ? ", task_id])
						task_aud_data = task_aud_data.sub_table{ |r| !((r.effortleft).nil?)}
						task_aud_data = task_aud_data.sub_table{ |r| !((r.originalestimate).nil?)}
						if(!(task_aud_data.empty?))
							task_aud_data.rename_column("agilefant_revision.timestamp", $TIME_STAMP_COL)
							task_aud_data.sort_rows_by!($TIME_STAMP_COL, :order => :descending)
							timestamp_col = task_aud_data.column($TIME_STAMP_COL)
							effortleft_col = task_aud_data.column($EFFORT_LEFT_COL)
							originalestimate_col = task_aud_data.column($ORIGINAL_ESTIMATE_COL)

							this_task_effort_left = Hash.new
							this_task_effort_estimate = Hash.new
							
							task_skip_iteration_array = Array.new
							task_iteration_array = iteration_array
							iter_cnt = 0
							iteration_array.each do |iter_start_date|
								iter_cnt += 1
								skip_this_iteration = 0
								iter_end_date = (iter_start_date >> 1) -1
								iter_end_date_index = iter_end_date - $g_startdate
								this_iter_days = iter_end_date - iter_start_date + 1
								flagdate = iter_end_date
								dayindex = iter_end_date_index
							
								break_iteration_loop_flag = 0
								last_estimate = 0
								last_estimate_data_point = 0
								last_effort_left = 0
							
									timestamp = timestamp_col[0]
									timepoint = Time.at(timestamp/1000).to_date
									col_index = 0
									timepoint_smaller_than_end_date_cnt = 0
									while(break_iteration_loop_flag<1)
										if(timepoint <= iter_end_date)
											timepoint_smaller_than_end_date_cnt += 1
										end
										if(timepoint < iter_start_date)
											break_iteration_loop_flag = 1
											timepoint = iter_start_date
											if((timepoint_smaller_than_end_date_cnt < 2 && iter_cnt > 1) || (effortleft_col[col_index]==0))
												flagdate = start_date - 1;
												task_skip_iteration_array << iter_start_date
												skip_this_iteration = 1
											end	
										end
										while ((flagdate + 1 - timepoint) > 0)
											if(flagdate <= $current_date)
												effortleft = effortleft_col[col_index]/60
												last_effort_left = effortleft
												$g_effortleft[dayindex] += effortleft												
												this_task_effort_left[iter_start_date.to_date] = effortleft				
											end
											estimate = originalestimate_col[col_index]
											last_estimate_data_point = estimate/60
											estimate = (estimate/60)/(this_iter_days-1.0)*(iter_end_date - flagdate)
											last_estimate = estimate
											$g_effortestimate[dayindex] += estimate								
											this_task_effort_estimate[iter_start_date.to_date] = estimate
											dayindex -= 1
											flagdate -= 1
										end # while ((flagdate + 1 - timepoint) > 0)
										col_index += 1
										if(col_index >= timestamp_col.length)
											break_iteration_loop_flag = 1
										else
											timestamp = timestamp_col[col_index]
											timepoint = Time.at(timestamp/1000).to_date
										end																									
									end # while(break_iteration_loop_flag<1)
								
								if(skip_this_iteration < 1)
									lastrowindex = dayindex + 1
									estimate_step = 0
									if(iter_end_date_index - lastrowindex > 0)
										estimate_step = last_estimate/(iter_end_date_index - lastrowindex)
									else
										estimate_step = last_estimate_data_point/(this_iter_days-1.0)
									end
									while(dayindex +1 > (iter_start_date - $g_startdate))
										if(flagdate <= $current_date)
											if(dayindex < effortleft_count)
												effortleft = estimate_step*(this_iter_days-1.0)
												$g_effortleft[dayindex] += effortleft
												this_task_effort_left[iter_start_date.to_date] = effortleft
											end
										end					
										estimate = estimate_step * (iter_end_date_index - dayindex)						
										$g_effortestimate[dayindex] += estimate
										this_task_effort_estimate[iter_start_date.to_date] = estimate
										dayindex -= 1
									end	
									
								end #if(skip_this_iteration < 1) 
							end # iteration_array.each do |iter_start_date|
							##fill missing iterations
							empty_iter_start = $g_startdate							
							task_iteration_array.delete_if {|x| task_skip_iteration_array.include?(x) }
							increase_order_iteration_array = task_iteration_array.sort
							increase_order_iteration_array.each do |iter_start_date|
								iter_start_date_index = iter_start_date - $g_startdate
								if ((empty_iter_start >> 1 - 1) < iter_start_date)
									dayindex = empty_iter_start - $g_startdate
									starting_dayindex = dayindex
									while (dayindex < iter_start_date_index)
										if(dayindex <= ($current_date - $g_startdate)) 
											if(starting_dayindex < 1)
												 
												$g_effortleft[dayindex] += this_task_effort_estimate[iter_start_date.to_date]
											else
												if(this_task_effort_left[iter_start_date.to_date].nil?)
													this_task_effort_left[iter_start_date.to_date] = 0
												end
												$g_effortleft[dayindex] += this_task_effort_left[iter_start_date.to_date]
											end
										end
										$g_effortestimate[dayindex] += this_task_effort_estimate[iter_start_date.to_date]
										dayindex += 1
									end	 
								end							
								empty_iter_start = iter_start_date >> 1 
							end
						end if(!(task_aud_data.empty?))
					end # task_id_col.each do |task_id|
				end # if(!(task_data.empty?))
			end # $story_iteration_map.each do |story_id, iteration_array|
		end

		def create_bpname_list(data)
			@bpnames = Array.new
			projects = data.column("businessProcess")
			projects.each do |entry|
				if (entry != nil)
					if (!(@bpnames.include?(entry)))
					@bpnames << entry
				end
				end
			end
			@bpnames << $ALL_PROJECTS
			@default_bpname = $ALL_PROJECTS
		end

		def create_usecase_list(data)
			@usecases = Array.new
			usecase_list = data.column("usecase_id")
			usecase_list.each do |usecase_id|
				usecase_lookup = $usecase_id_name_map[usecase_id]
				if (usecase_lookup != nil)
					usecase = usecase_lookup.split('@')[0]
					if(!(@usecases.include?(usecase)))
					@usecases << usecase
				end
				end
			end
			@usecases << $ALL_USECASES
			@default_usecase = $ALL_USECASES
		end

end
