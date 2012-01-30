class Fragment < ActiveRecord::Base

  attr_accessor :name

  attr_accessor :calc_start
  attr_accessor :calc_stop
  attr_accessor :path_priority

  
  def setFields(inpath_priority)
    
   
    @path_priority=inpath_priority
    puts "Initialized Fragment"
  end
  
  def dump 
       puts "Frag Id: #{id}, Allocated: #{allocated}, ItId #{build_iteration_id}, User #{user_id} Points #{points}, Path: #{path_id}, Calc_start: #{@calc_start}, Calc_stop #{@calc_stop} , path_priority #{@path_priority}"
  end   
  
    

end
