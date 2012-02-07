class BuildIteration < ActiveRecord::Base
  has_many :iteration_resources, :dependent => :destroy
  has_many :users, :through => :iteration_resources 
  has_many :fragments
  
  attr_accessor :bandwidth
  attr_accessor :ppdi
  attr_accessor :countsToPpdi
  attr_accessor :startingCapacity
  attr_accessor :endingCapacity
  attr_accessor :biResources
  
  
  def calculateBandwidthAndPpdi
    
  
  
      puts "calculateBandwidthAndPpdi"
      puts "    BI: #{id}, Banked Points= #{banked_points.to_f}"
# to calculate the bandwidth for a given build iteration we consult iteration resources
    puts "  select from iteration_resources where build_iteration_id = #{id}"
    irs = IterationResource.where("build_iteration_id=:id",{:id=> id})
       @bandwidth=0.0
       for ir in irs
        puts "    Iteration Resource: Id= #{ir.id}, Pct= #{ir.resource_pct}"
          
         @bandwidth = @bandwidth + ir.resource_pct.to_f/100
       
      
         puts "    Bandwith So Far: #{@bandwidth.to_f}"
       end     
       puts "  checking for banked points"
       puts "    BI: #{id}, Banked Points= #{banked_points.to_f}, Bandwith final=#{@bandwidth.to_f}"
       if banked_points != nil
          puts "    Has Banked Points"
          @ppdi = (banked_points.to_f) / (@bandwidth.to_f)
           puts "    PPDI: #{@ppdi}"
       end
  
  end
  
  def setStartingCapacity
    @startingCapacity=remaining
  end
  
  def setEndingCapacity
    @endingCapacity=remaining
  end
  def countsToPpdi
    if banked_points
       @countsToPpdi=1
    else 
       @countsToPpdi=0
    end    
  end
  
  def setCapacities(ppdiglobal)
    puts "Setting Capacities, using an global ppdi of #{ppdiglobal}"
    @capacities = Hash.new("Capacities") 
    @biResources=0.0
#    puts "    BI: #{id}, Banked Points= #{banked_points.to_f}"
    irs = IterationResource.where("build_iteration_id=:id",{:id=> id})
    for ir in irs
#      puts "    Iteration Resource: Id= #{ir.id}, User Id= #{ir.user_id}, Pct= #{ir.resource_pct}"
          
     
      @capacities[ir.user_id]=ir.resource_pct.to_f / 100.0 * ppdiglobal
#      puts @capacities[ir.user_id]
      @biResources = @biResources + ir.resource_pct.to_f / 100.0
    end     
#    puts "Capacities by user id for iteration #{id}"
#    @capacities.each { |key,value| puts "#{key} = #{value}"}
  end
  
  def remaining
    total = 0.0
    @capacities.each { |key,value| total = total + value} 
    return total
  end
  
  def fitFragment(hpf,globalPpdi,hoursPerIteration)
    remainder =0.0
    highestCapacity=0.0
    hcIndex=0
    keys = @capacities.keys
    keys.each do |key|
      capacity = @capacities[key]
      if capacity > highestCapacity 
        highestCapacity = capacity
        hcIndex = key
      end   
     end
     
    if highestCapacity == 0.0 
      return hpf.points
    end
    
    if highestCapacity < hpf.points
      remainder = hpf.points - highestCapacity
      hpf.points = highestCapacity
      hpf.build_iteration_id = id
      hpf.calc_start = start_date
      hpf.calc_stop = stop_date
      hpf.user_id = hcIndex
      hpf.allocated=1
      hpf.hours_equivalent=hoursPerIteration * hpf.points / globalPpdi
      @capacities[hcIndex]=0.0
    else
      @capacities[hcIndex]=highestCapacity-hpf.points
      hpf.build_iteration_id = id
      hpf.calc_start = start_date
      hpf.calc_stop = stop_date
      hpf.user_id = hcIndex
      hpf.allocated =1
      hpf.hours_equivalent=hoursPerIteration * hpf.points / globalPpdi
    end
    
    return remainder
    
  end
  
  
end
