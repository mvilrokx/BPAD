class ReportsController < ApplicationController
	before_filter :login_required

	$ALL_ITERATIONS = "All Iterations"
	$ALL_PROJECTS = "All Projects"
	$ALL_USECASES = "All Use Cases"
	$EFFORT_LEFT_COL = "effortleft"
	$ORIGINAL_ESTIMATE_COL = "originalestimate"
	$TIME_STAMP_COL = "timestamp"

	$g_dates = Array.new
	$g_effortleft = Array.new
	$g_effortestimate = Array.new
	$current_date = Date.today
	
	def index

	$end_date_all_iterations = Date.new((Date.today>>3).year,(Date.today>>3).month,1)-1

	afStory = AfStory.new
	$usecase_id_name_map = afStory.getUsecaseNames 
	$usecase_project_id_map = afStory.getUsecasenameProjectUasecaseIdMap
	$usecase_story_hash = afStory.getUsecaseStoryMap
	$iter_project_usecase_hash = afStory.getIterationProjectUsecaseMap

	afBacklog = AfBacklog.new
	$iteration_startdate_map = afBacklog.getIterationStartdateMap
	$project_id_map = afBacklog.getProjectIdMap
	$project_iter_id_map = afBacklog.getIterationProjectIdHash
	$iteration_name_ids_map = afBacklog.getIterationNameIdsMap

	$g_iteration_order = $iteration_startdate_map.keys

	@iterations = $g_iteration_order
	@iterations << $ALL_ITERATIONS		
	@default_iteration = $ALL_ITERATIONS

	project_data = Array.new
	$iter_project_usecase_hash.each do |iter_id, project_hash|
		project_hash.each do |project_id, usecase_array|
			project_data << project_id
		end
	end

	usecase_data = Array.new
	$usecase_story_hash.each do |usecase_id, story_array|
		usecase_data << usecase_id
	end 

	story_data = Array.new 
	$usecase_story_hash.each do |usecase_id, story_array|
		if(!story_array.nil?)
			story_array.each do |story_id|
				story_data << story_id 
			end 
		end 
	end 
	
	create_bpname_list(project_data)
	create_usecase_list(usecase_data)
	get_start_end_date_for_all_iterations
	cal_story_iteration_startDate_mapping(story_data)
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
		
		usecase_data = getSelectedUsecaseArray(iteration, project)
		story_data = Array.new
		if(usecase.eql?($ALL_USECASES))
			if(!usecase_data.nil?)
				usecase_data.each do |usecase_id|
					story_array = $usecase_story_hash[usecase_id]
					if(!story_array.nil?)
						story_array.each do |story_id|
							story_data << story_id
						end 
					end 
				end 
			end 
		else
			lookup_usecase = Array.new 
			lookup_usecase << usecase 
			lookup_usecase << project
			story_array = $usecase_story_hash[$usecase_project_id_map[lookup_usecase]]
			if(!story_array.nil?)
				story_array.each do |story_id|
					story_data << story_id
				end 
			end 
		end 
		
		get_start_end_date_for_all_iterations
		cal_story_iteration_startDate_mapping(story_data)
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
		project_data = Array.new
		usecase_data = Array.new 
		if(iteration.eql?($ALL_ITERATIONS))
			$iter_project_usecase_hash.each do |iter_id, project_hash|
				if(!project_hash.nil?)
					project_hash.each do |project_id, usecase_array|
						if(!project_data.include?(project_id))
							project_data << project_id 
						end 
					end 
				end 
			end 
			$usecase_story_hash.each do |usecase_id, story_array|
				if(!story_array.nil?)
					usecase_data << usecase_id 
				end 
			end 
		else
			iter_id_array = $iteration_name_ids_map[iteration]
			if(!iter_id_array.nil?)
				iter_id_array.each do |iter_id|
					project_hash = $iter_project_usecase_hash[iter_id] 
					if(!project_hash.nil?)
						project_hash.each do |project_id, usecase_array|
							if(!usecase_array.nil?)
								if(!project_data.include?(project_id))
									project_data << project_id 
								end 
								usecase_array.each do |usecase_id|
									if(!usecase_data.include?(usecase_id))
										usecase_data << usecase_id
									end 									
								end 
							end 
						end 
					end 
				end 
			end 
		end #if(iteration.eql?($ALL_ITERATIONS))
		$current_iteration = iteration
		create_bpname_list(project_data)
		create_usecase_list(usecase_data)
		render :partial => 'select_project'
	end 

	def project_change_listener
		project = params[:id]
		usecase_data = getSelectedUsecaseArray($current_iteration, project)
		create_usecase_list(usecase_data)
		render :partial => 'select_usecase'
	end
	
	private 

		def getSelectedUsecaseArray(iteration, project)
			usecase_data = Array.new
			if($current_iteration.eql?($ALL_ITERATIONS)) 
			$iter_project_usecase_hash.each do |iter_id, project_hash|
				if(!project_hash.nil?)
					if(project.eql?($ALL_PROJECTS))
						project_hash.each do |project_id, usecase_array|
							if(!usecase_array.nil?)
								usecase_array.each do |usecase_id|
									if(!usecase_data.include?(usecase_id))
										usecase_data << usecase_id 
									end 									
								end
							end
						end 
					else
						project_lookup = Array.new 
						project_lookup << project
						project_lookup << iter_id
						usecase_array = project_hash[$project_iter_id_map[project_lookup]]
						if(!usecase_array.nil?)
							usecase_array.each do |usecase_id|
								if(!usecase_data.include?(usecase_id))
									usecase_data << usecase_id
								end 	
							end
						end
					end #if(project.eql?($ALL_PROJECTS))
				end #if(!project_hash.nil?)
			end #$iter_project_usecase_hash.each do |iter_id, project_hash|
		else
			iter_id_array = $iteration_name_ids_map[iteration]
			if(!iter_id_array.nil?)
				iter_id_array.each do |iter_id|
					project_hash = $iter_project_usecase_hash[iter_id] 
					if(!project_hash.nil?)
						if(project.eql?($ALL_PROJECTS))
							project_hash.each do |project_id, usecase_array|
								if(!usecase_array.nil?)
									usecase_array.each do |usecase_id|
										if(!usecase_data.include?(usecase_id))
											usecase_data << usecase_id
										end 	
									end
								end
							end 
						else
							project_lookup = Array.new 
							project_lookup << project 
							project_lookup << iter_id 
							usecase_array = project_hash[$project_iter_id_map[project_lookup]]
							if(!usecase_array.nil?)
								usecase_array.each do |usecase_id|
									if(!usecase_data.include?(usecase_id))
										usecase_data << usecase_id
									end 	
								end
							end
						end #if(project.eql?($ALL_PROJECTS))
					end #if(!project_hash.nil?)
				end #iter_id_array.each do |iter_id|
			end #if(!iter_id_array.nil?)
		end
		return usecase_data
		end 

		def get_start_end_date_for_all_iterations
			afBacklog = AfBacklog.new 
			dates = afBacklog.getStartEndDateForAllProjects
			startdate = dates[0]
			enddate = dates[1]
			if(enddate > $end_date_all_iterations)
				enddate = $end_date_all_iterations
			end	
			$g_startdate = startdate
			$g_enddate = enddate
		end

		def cal_story_iteration_startDate_mapping(data)
			$story_iteration_map = Hash.new
			story_id_col = data
			afStoryAud = AfStoryAud.new
			story_id_backlog_id_hash = afStoryAud.getStoryIdBacklogIdMap(story_id_col)

			afBacklog = AfBacklog.new
			iteration_start_end_hash = afBacklog.getIterationIdStartdateMap

			story_id_backlog_id_hash.each do |story_id, iteration_id_array|

				iteration_start_date_array = Array.new			
			
				iteration_id_array.each do |iter_id|
					startdate = iteration_start_end_hash[iter_id]
					if(!startdate.nil?)
						startdate = startdate.to_date
						enddate = (startdate >> 1) -1
						if((!iteration_start_date_array.include?(startdate)) && (enddate <= $end_date_all_iterations))
							iteration_start_date_array << startdate
						end
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

			afTask = AfTask.new 
			taskdata = afTask.getStoryTaskHash($story_iteration_map.keys)
			story_task_hash = taskdata[0]
			task_array = taskdata[1]

			afTaskAud = AfTaskAud.new
			taskAuddata = afTaskAud.getTaskAudDataHash(task_array)
			task_aud_data_hash = taskAuddata[0]
			rev_col = taskAuddata[1]

			afAgilefantRevision = AfAgilefantRevision.new
			rev_timestamp_hash = afAgilefantRevision.getRevTimeHash(rev_col)

			$story_iteration_map.each do |story_id, iteration_array|
				task_id_col = story_task_hash[story_id]
				if(!(task_id_col.nil?))

					task_id_col.each do |task_id|

						task_aud_data = task_aud_data_hash[task_id]

						if(!(task_aud_data.nil?))
							task_aud_data.add_column($TIME_STAMP_COL) { |r| rev_timestamp_hash[r.REV]}
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
													this_task_effort_left[iter_start_date.to_date] = this_task_effort_estimate[iter_start_date.to_date]
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
						end #if(!(task_aud_data.empty?))
					end # task_id_col.each do |task_id|
				end # if(!(task_data.empty?))
			end # $story_iteration_map.each do |story_id, iteration_array|
		end

		def create_bpname_list(data)
			@bpnames = Array.new
			data.each do |id|
				if (id != nil)
					entry = $project_id_map[id]
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
			usecase_list = data
			usecase_list.each do |usecase_id|
				usecase = $usecase_id_name_map[usecase_id]
				if (usecase != nil)
					if(!(@usecases.include?(usecase)))
					@usecases << usecase
				end
				end
			end
			@usecases << $ALL_USECASES
			@default_usecase = $ALL_USECASES
		end

end
