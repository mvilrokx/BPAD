module Trackable
  attr_accessor :do_not_track

  def self.included(base)
    base.before_validation :check_out, :unless => :do_not_track
    base.validates_presence_of :iteration_id, :message => "You have not picked an Iteration.  Please go to your account and pick an iteration before you perform this action", :unless => defined?(:do_not_track) ? :do_not_track : false
  end

	def check_out
		if checkoutable?
			if User.find(WatchingObserver.current_user).iteration.open?
			  self.iteration_id = User.find(WatchingObserver.current_user).iteration.id
		  else
				errors.add_to_base("You can not checkout objects against a closed iteration")
				false
		  end
		else
			errors.add_to_base("This object is currently used in iteration '#{self.iteration.name}' and therefor locked (you are in iteration '#{User.find(WatchingObserver.current_user).iteration.name}').  In order to be able to update this object you can switch to this iteration or wait for the iteration to finish.")
			false
		end
	end

	def checkoutable?
		self.iteration_id.nil? || self.iteration_id == User.find(WatchingObserver.current_user).iteration.id
	end

	#def check_in
	#	self.iteration_id = nil
	#end

end
