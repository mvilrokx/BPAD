class ReportsController < ApplicationController
	before_filter :login_required

	$ALL_ITERATIONS = "All Iterations"
	$ALL_PROJECTS = "All Projects"
	$ALL_USECASES = "All Use Cases"
	$TASK_NAME_COL = "task_name"
	$STORY_NAME_COL = "story_name"
	$USECASE_ID_COL = "usecase_id"
	$ITERATION_COL = "iteration"
	$STARTDATE_COL = "startDate"
	$ENDDATE_COL = "endDate"
	$BUSINESS_PROCESS_COL = "businessProcess"
	$EFFORT_LEFT_COL = "effortleft"
	$ORIGINAL_ESTIMATE_COL = "originalestimate"

  $bpeffortLeftName = 0
  $bpeffortEstimateName = 1
	$effortLeftSum = 2
	
	$g_dates = Array.new
	$g_effortleft = Array.new
	$g_effortestimate = Array.new

	$current_date = Date.today
	
	def index
	@all_tasks_info = AfTask.report_table(:all, :only=>[:name, :effortleft, :originalestimate], :include =>{:story => {:only => [:name, :parent_id], :include => {:backlog =>{:only => [:name, :startDate, :endDate, :backlogtype], :include =>{:businessProcess => {:only=>[:name]}}}}}})

  @all_tasks_info.rename_column("name", "task_name");
	@all_tasks_info.rename_column("story.name", "story_name")
	@all_tasks_info.rename_column("story.parent_id", "usecase_id")
	@all_tasks_info.rename_column("backlog.name","iteration")
	@all_tasks_info.rename_column("backlog.startDate","startDate")
	@all_tasks_info.rename_column("backlog.endDate","endDate")
	@all_tasks_info.rename_column("businessProcess.name","businessProcess")
	@all_tasks_info.rename_column(":effortleft",$EFFORT_LEFT_COL)
	@all_tasks_info.rename_column(":originalestimate",$ORIGINAL_ESTIMATE_COL)

	$all_task_data = @all_tasks_info
	
	afStory = AfStory.new
	$usecase_id_name_map = afStory.getUsecaseNames 

	a = $all_task_data
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
	data = $all_task_data
	create_bpname_list(data)
	create_usecase_list(data)
	cal_chart_all_iterations(data)
	@dates = $g_dates
	@effortestimate = $g_effortestimate
	@effortleft = $g_effortleft
	@chartLabel = @default_iteration + " " + $ALL_PROJECTS + " " + $ALL_USECASES
	$current_iteration = @default_iteration
	
	end

	def updateChart
		iteration = params[:iterations][:id]
		project = params[:projects][:id]
		usecase = params[:usecases][:id]
		@chartLabel = iteration + " " + project+ " " + usecase
		@dates_effort_left = Array.new
		@dates_original_estimate = Array.new
		@effortestimate = Array.new
		@effortleft = Array.new
		if(!iteration.eql?($ALL_ITERATIONS))
			data = $all_task_data.sub_table{ |r| (r.iteration).eql?(iteration)}
			if(!project.eql?($ALL_PROJECTS))
				data = data.sub_table{ |r| (r.businessProcess).eql?(project)}
			end
			if(!usecase.eql?($ALL_USECASES))
				data = data.sub_table{ |r| (r.usecase_id).eql?($usecase_id_name_map.index(usecase))}
			end
			cal_chart(data)
		end
		if(iteration.eql?($ALL_ITERATIONS))
			data = $all_task_data
			if(!project.eql?($ALL_PROJECTS))
				data = data.sub_table{ |r| (r.businessProcess).eql?(project)}
			end
			if(!usecase.eql?($ALL_USECASES))
				data = data.sub_table{ |r| (r.usecase_id).eql?($usecase_id_name_map.index(usecase))}
			end
		
			cal_chart_all_iterations(data)
		end
		@dates = $g_dates
		@effortestimate = $g_effortestimate
		@effortleft = $g_effortleft
		render :partial => 'show_chart'
	end

	
	def iteration_change_listener
		iteration = params[:id]
		data = $all_task_data
		if(!iteration.eql?($ALL_ITERATIONS))
			data = $all_task_data.sub_table{ |r| (r.iteration).eql?(iteration)}
		end
		$current_iteration = iteration
		create_bpname_list(data)
		create_usecase_list(data)
		render :partial => 'select_project'
	end

	def project_change_listener
		project = params[:id]
		data = $all_task_data
		if(!$current_iteration.eql?($ALL_ITERATIONS)) 
			data = $all_task_data.sub_table{ |r| (r.iteration).eql?($current_iteration)}
		end
		if(!project.eql?($ALL_PROJECTS))
			data = data.sub_table{ |r| (r.businessProcess).eql?(project)}
		end
		create_usecase_list(data)
		render :partial => 'select_usecase'
	end

	private 
		def cal_chart(data)
			$g_dates.clear
			$g_effortleft.clear
			$g_effortestimate.clear
			effort_left_sum = (data.sigma($EFFORT_LEFT_COL))/60.0
			original_estimate_sum = (data.sigma($ORIGINAL_ESTIMATE_COL))/60.0
			estimate_when_done = 0.0
			start_date = data.column($STARTDATE_COL)[0].to_date
			end_date = data.column($ENDDATE_COL)[0].to_date
			effort_left_end_date = end_date
			start_date_index = 1.0
			end_date_index = end_date - start_date + 1.0
			effort_left_end_date_index = end_date_index
			if($current_date > start_date && $current_date < end_date)
				effort_left_end_date = $current_date		
				effort_left_end_date_index = $current_date - start_date		
			end
			$g_dates << start_date.to_s
			$g_effortleft << original_estimate_sum
			$g_effortestimate << original_estimate_sum
			if(effort_left_end_date < end_date)
				$g_dates << effort_left_end_date.to_s
				estimate_at_today = original_estimate_sum/(end_date - start_date - 1.0) * (end_date - effort_left_end_date)				
				$g_effortestimate << estimate_at_today
			end
			$g_dates << end_date.to_s				
			$g_effortleft << effort_left_sum			
			$g_effortestimate << estimate_when_done 
		end

		def cal_chart_all_iterations(data)
			$g_dates.clear
			$g_effortleft.clear
			$g_effortestimate.clear
			effort_left_estimate_total = 0
			start_date = $current_date
			data = Grouping(data, :by=>$ITERATION_COL)
			
			sort_data = Array.new
			data.each do |iteration, group|
				i = $g_iteration_order.index(iteration)
				if(i!= nil)
					sort_data[i] = group
				end
			end

			sort_data.each do |group|
				if(!group.nil?)				
					start_date = group.column($STARTDATE_COL)[0].to_date 
					end_date = group.column($ENDDATE_COL)[0].to_date 
					effort_left = (group.sigma($EFFORT_LEFT_COL))/60.0 + effort_left_estimate_total
					original_estimate_this_iteration = (group.sigma($ORIGINAL_ESTIMATE_COL))/60.0
					original_estimate = original_estimate_this_iteration + effort_left_estimate_total					
					$g_dates << (end_date + 1).to_s
					$g_effortestimate << effort_left_estimate_total 
					if($current_date > start_date)
						$g_effortleft << effort_left
						if($current_date < end_date)
							$g_dates << ($current_date + 1).to_s
							estimate_at_today = original_estimate_this_iteration/(end_date - start_date - 1.0) * (end_date - $current_date) + effort_left_estimate_total
							$g_effortestimate << estimate_at_today
						end
					end 
					effort_left_estimate_total = original_estimate
				end
			end
			$g_dates << (start_date + 1).to_s
			$g_effortleft << effort_left_estimate_total 
			$g_effortestimate << effort_left_estimate_total
			$g_dates.reverse!
			$g_effortleft.reverse!
			$g_effortestimate.reverse!
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
