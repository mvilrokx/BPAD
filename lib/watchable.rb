module Watchable

	def owner
		self.watchings.find(:first, {:conditions => ["creator = 1"]}).user
		rescue
			nil
	end

end
