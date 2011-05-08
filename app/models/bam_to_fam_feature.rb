class BamToFamFeature < ActiveRecord::Base

  belongs_to :bam_to_fam_map
  belongs_to :feature
  belongs_to :step

  after_save :reset_approvals
  after_destroy :reset_approvals
  

	def interested_parties
  	@interested_parties = []
	  @interested_parties << self.feature.interested_parties
	  @interested_parties << self.step.interested_parties
	  @interested_parties.flatten.compact
	end
	
	def name
	  feature.name
	end

  protected
		def reset_approvals
			step.unmap! if step.mapped?
		  # Remove old approvers
		  for approval in bam_to_fam_map.approvals
		    approval.destroy
	    end		    
		  # Add New approvers
	    for watching in interested_parties
   			bam_to_fam_map.approvals.find_or_create_by_user_id(watching[:user_id]) if watching[:user_id]
	    end
		end

end
