module Watchable

	def owner
		self.watchings.find(:first, {:conditions => ["creator is not null"]}).user
		rescue
			nil
	end

end
