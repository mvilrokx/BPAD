class BamToFamFeature < ActiveRecord::Base
  # attr_accessible :feature_id, :bam_to_fam_map_id
  belongs_to :bam_to_fam_map
  belongs_to :feature
  belongs_to :step

	def interested_parties
  	@interested_parties = []
	  @interested_parties << self.feature.interested_parties
	  @interested_parties << self.step.interested_parties
	  @interested_parties.flatten.compact
	end
	
	def name
	  feature.name
	end

end
