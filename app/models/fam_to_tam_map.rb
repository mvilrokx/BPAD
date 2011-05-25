class FamToTamMap < ActiveRecord::Base
  belongs_to :feature
  belongs_to :build_feature

	def name
	  build_feature.name
	end

	def description
	  build_feature.description
	end

end
