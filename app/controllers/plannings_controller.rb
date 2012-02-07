class PlanningsController < ApplicationController
	before_filter :login_required
	before_filter :iteration_required, :except => [:index, :show]
	helper_method :sort_column, :sort_direction
	 
	def calc
	
	    setAgilefantMonths
	    planningRun = PlanningRun.new()
	    
	   @users = User.all
#    @bis = BuildIteration.where("order by start_date")
    @bis = BuildIteration.all
 
#    
#   @allPaths = Path.where("id<:id and points>0 and points is not null ",{:id=> 33}).order("priority")
#    @allPaths = Path.where("points>0 and points is not null and life_cycle_status in ('Placeholder','Mapped','Detailed','Detailing') and id in (select p.id from paths p,taggings t, tags tgs, business_processes b where t.tag_id = tgs.id and b.id = p.business_process_id and tgs.name = '1.3m' and t.path_id = p.id)").order("priority")
     @allPaths = Path.where("points is not null and points>0 and life_cycle_status in ('Placeholder','Mapped','Detailed','Detailing')").order("priority")
    
	    
	    plan_paths
	    puts "JUST BEFORE SAVE"
      dumpPaths
      for path in @allPaths
       
       path.save
      end
      
# store some run data      
      planningRun.ppdi = @ppdi
      planningRun.number_its_used = @itsUsedForPpdi
      planningRun.number_paths_planned = @pathsScheduled
      planningRun.iteration_capacity_used = @usedCapacity
      planningRun.points_of_planned_paths = @pointsTotal
      planningRun.planned_months_in_agilefant = @noOfMonthsPlannedInAgilefant
      planningRun.messages = @messages
      planningRun.save
      
     
      
      for bi in @bis
        bi.resource_count=bi.biResources
        bi.point_capacity=bi.startingCapacity
        bi.post_planning_capacity=bi.endingCapacity
        bi.save!
      end
   
      
      redirect_to :action => 'index'

	end
	
	def setAgilefantMonths
	    @hoursPerIteration =130.0
	    @noOfMonthsPlannedInAgilefant =1
	end
	
  def index
    setAgilefantMonths 
  
    @planningRun = PlanningRun.last
    @users = User.all
    
#    @bis = BuildIteration.where("order by start_date")
    @bis = BuildIteration.all
 
#    
#   @allPaths = Path.where("id<:id and points>0 and points is not null ",{:id=> 33}).order("priority")
    @allPaths = Path.where("points is not null  and points>0 and life_cycle_status in ('Placeholder','Mapped','Detailed','Detailing')").order("priority")
    
#   now get the path which is the last occurance of each tag in the system
    @tagEndPositions = Path.find_by_sql('select tgs.name,p.priority,p.id from paths p, taggings t, tags tgs where t.tag_id = tgs.id and t.path_id = p.id and p.priority = (select max(p1.priority) from paths p1, taggings t1, tags tgs1 where t1.tag_id = tgs1.id and t1.path_id = p1.id and t1.tag_id = t.tag_id)' )
    
begin    
      for path in @allPaths
      path.lastTagOccurance =''
        for tagEndPosition in @tagEndPositions
#          puts tagEndPosition.name
          if path.id == tagEndPosition.id
#            puts "found it #{tagEndPosition.name} #{path.id}"
            path.lastTagOccurance =  path.lastTagOccurance + ',' + tagEndPosition.name
          end
        end
      end          
end                   
                   
#    @allPaths = Path.all
   
      
    
    

    
     
     
#     @allPaths = Path.paginate(:page => params[:page], :order => sort_column(Path) + " " + sort_direction)
   

  end
  
  def plan_paths
   
    
#clean out any existing fragments in the db
    @allFragments = Fragment.all
    for toNuke in @allFragments
       toNuke.destroy
    end    
    
    for path in @allPaths
# set max_developers to 1 if not assigned any number in the     
       if path.max_developers==nil
          path.max_developers=1
       end
    
    end   
    
#figure out how much bandwidth we have for each build iteration    
    developerVelocitySum=0
    count =0
    for bi in @bis
       puts "Calling Calc"
       bi.calculateBandwidthAndPpdi   
       puts "Build Iteration: Id= #{bi.id}, Start= #{bi.start_date},BandWidth= #{bi.bandwidth}, Points=#{bi.banked_points}, PPDI=#{bi.ppdi},"
       if bi.countsToPpdi == 1
         developerVelocitySum+=bi.ppdi 
         count+=1 
       end 
    end
    
    @ppdi = developerVelocitySum.to_f/count.to_f
    @itsUsedForPpdi=count
    puts "ppdi #{@ppdi}"
    puts "its used #{@itsUsedForPpdi}"
    
# find the points capacities by resource based on our calculated ppdi and resources allocation to iteration
     for bi in @bis
       bi.setCapacities(@ppdi)
       bi.setStartingCapacity
     end
   
# now calculate a starting capacity, for all future iterations .. this will act as a checksum for the whole calculation    
    startingCapacity = iterationsRemainingCapacity
    
    accountForMaxDev
    
    
#    dumpPaths
#    dumpFragments
    dumpIterations
    
# now schedule fragments to iterations, breaking up as necessary

    count =0
    
    while idOfHighestPriorityUnallocatedFragment!=-1
    
      count = count +1
      puts "Count of scheduling efforts #{count}"
      if count > 100000
        @message = "Calculation Stopped Prematurely"
        break 
      end
      
      highestPriorityId = idOfHighestPriorityUnallocatedFragment
      fragToSchedule = @fragments[highestPriorityId]
    
       @countMonthsInAgile = 0
      for bi in @bis
#         puts "Checking Iteration Should be used for scheduling: Id= #{bi.id}, Start= #{bi.start_date},BandWidth= #{bi.bandwidth}, Points=#{bi.banked_points}, PPDI=#{bi.ppdi},"
       
         if bi.start_date > Date.parse(Time.now.strftime('%Y/%m/%d'))
           
           @countMonthsInAgile = @countMonthsInAgile + 1
           puts "now checking if need to hold off because planned in agilefant #{@countMonthsInAgile}"
           if @countMonthsInAgile > @noOfMonthsPlannedInAgilefant
           
           puts "Considering Iteration: Id= #{bi.id}, Start= #{bi.start_date},BandWidth= #{bi.bandwidth}, Points=#{bi.banked_points}, PPDI=#{bi.ppdi},"
          
           fragmentSize = fragToSchedule.points
           puts "Need to find a slot for #{fragToSchedule.points} points, iteration has #{bi.remaining} points"
           remainder = bi.fitFragment(fragToSchedule,@ppdi,@hoursPerIteration)
           puts "Remainder #{remainder}"
           if remainder == 0.0 
              puts "Fragment Completely Scheduled in Iteration"
              fragToSchedule.dump
    
              break
           end
           if remainder != fragmentSize
              puts "Fragment partially scheduled in this iteration .. spliting"
              fragToSchedule.dump
              
              
              newFrag = Fragment.new({:allocated=>0,:build_iteration_id=>-1,:path_id=>fragToSchedule.path_id,:points=>remainder,:id=>@fragmentIndex})
              newFrag.id = @fragmentIndex
              newFrag.setFields(fragToSchedule.path_priority)
              @fragments[@fragmentIndex]=newFrag
              puts "Added Fragment Id #{newFrag.id}"
              @fragmentIndex=@fragmentIndex+1
              break  
           end
           if remainder == fragmentSize
              puts "Iteration has no capacity, move on ..."
           end
           
           end
      
         end
      end
#end of loop over iterations
      if highestPriorityId == idOfHighestPriorityUnallocatedFragment
         puts "Not Enough Capacity in Iterations, add more resources or Iterations"
         break
      end      
    end

   
    
    dumpPaths
#    dumpFragments
    dumpIterations
    
    endingCapacity = iterationsRemainingCapacity
    usedCapacity = startingCapacity - endingCapacity
    pointsTotal=0.0
    for path in @allPaths
      pointsTotal = pointsTotal + path.points
    end
    shouldBeZero = usedCapacity - pointsTotal
    puts "Used Capacity #{usedCapacity}"
    puts "Points Total #{pointsTotal}"
    
    @pathsScheduled = @allPaths.count
    @usedCapacity = usedCapacity
    @pointsTotal = pointsTotal
    @message = "Clean Calculation"
    
    if shouldBeZero > 0.01
       @message = "PROBLEM WITH POINTS CALCULATION!!!! . Bandwidth used does not agree with points total of scheduled paths!!!!"
       puts @message
      
    end
    
    notePathStartStopIterations
#just for reporting purposes    
     for bi in @bis
   
       bi.setEndingCapacity
     end
     
#persist fragments     
    keysS = @fragments.keys
    keysS.each do |key|
    fragToSave = @fragments[key]
        puts "copy and save"
        fragToSave.dump
     
        fragToSave.save!
    end     
   
 end
 
 
  def iterationsRemainingCapacity
    puts "Calculating Remaining Capacity in Iterations"
    capacity=0.0
    for bi in @bis
       capacity = capacity + bi.remaining()
       puts "Running Total #{capacity}"
    end
    return capacity
  end
  
  def dumpIterations
     puts "Iterations ..."
     for bi in @bis
       puts "id: #{bi.id}, start: #{bi.start_date}, Remaining: #{bi.remaining}"
     end
  end
  
  def dumpPaths
     puts "Paths ..."
     for path in @allPaths
       puts "id: #{path.id} priority #{path.priority} points: #{path.points} start #{path.calc_start_it} stop #{path.calc_stop_it}"
     end
  end
  
  def dumpFragments
    puts "Fragments ..."
         keys = @fragments.keys
         keys.each do |key|
           lf = @fragments[key]
           puts "Frag Id: #{lf.id}, Allocated: #{lf.allocated}, ItId #{lf.build_iteration_id}, Points #{lf.points}, Path: #{lf.path_id} "
         end
  end
  

  def accountForMaxDev
    @fragments = Hash.new("Fragments")
    @fragmentIndex=1
    for path in @allPaths
      puts "Processing Path for Fragments"
      for i in 1..path.max_developers
         puts "  Developer"
         

         fragment = Fragment.new({:allocated=>0,:build_iteration_id=>-1,:path_id=>path.id,:points=>path.points.to_f/path.max_developers.to_f,:id=>@fragmentIndex})
         fragment.id =@fragmentIndex
         fragment.setFields(path.priority)
        
         fragment.dump
         @fragments[@fragmentIndex]=fragment
         puts "id of new fragment #{@fragments[@fragmentIndex].id}"
         @fragmentIndex=@fragmentIndex+1
      end
    end
    
  end
  
  def idOfHighestPriorityUnallocatedFragment
    hpid = -1
    highestPriority = -1
    keys = @fragments.keys
    
    keys.each do |key|
      lf = @fragments[key]
       
     
      if lf.allocated == 0
        puts "Unallocate: Key: #{key}, Fragment Priority: #{lf.path_priority},Alloc #{lf.allocated} "
        if lf.path_priority < highestPriority || highestPriority == -1
          
          hpid = lf.id
          highestPriority = lf.path_priority
          puts "Found lower priority: #{highestPriority} belongs to fragment: #{hpid}"
        end
      end
    end  
    puts "Highest Priority to Schedule is: #{highestPriority} belongs to fragment: #{hpid}"
    return hpid  
  end
  
  def notePathStartStopIterations
     for path in @allPaths
     path.calc_start_it = nil
     path.calc_stop_it = nil 
     puts "id: #{path.id} priority #{path.priority} points: #{path.points} start #{path.calc_start_it} stop #{path.calc_stop_it}"  
       keys = @fragments.keys
       keys.each do |key|
         lf = @fragments[key]
#         lf.dump
         if lf.path_id == path.id
           puts "Fragment belongs to path P: #{path.calc_start_it} #{path.calc_start_it.class} #{path.calc_stop_it} #{path.calc_stop_it.class} F: #{lf.calc_start} #{lf.calc_start.class} #{lf.calc_stop} #{lf.calc_stop.class} "
           lf.dump
           if path.calc_start_it == nil 
              puts "setting nill path start to frag start"
              path.calc_start_it = lf.calc_start
           end
           if lf.calc_start < path.calc_start_it 
             puts "frag start < path start "
             path.calc_start_it = lf.calc_start
           end
           if path.calc_stop_it == nil 
              puts "setting nil path stop to frag stop"
              path.calc_stop_it = lf.calc_stop
           end
           if lf.calc_stop > path.calc_stop_it 
             puts "frag stop > path stop "
            path.calc_stop_it = lf.calc_stop
           end
         end
       end
        
     end    
  end
    
end

