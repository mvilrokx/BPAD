class BamToFamFeature < ActiveRecord::Base

  belongs_to :bam_to_fam_map
  belongs_to :feature
  belongs_to :step

#  after_save :reset_approvals
  after_update :reset_approvals
  after_destroy :reset_approvals
  

	def interested_parties
  	@interested_parties = []
	  @interested_parties << self.feature.interested_parties if feature
	  @interested_parties << self.step.interested_parties if step
	  @interested_parties.flatten.compact
	end
	
	def name
	  feature.name
	end

	def description
	  feature.description
	end

  def deep_clone(step)
    ap step
    new_bam_to_fam_feature = clone
    new_bam_to_fam_feature.created_at = new_bam_to_fam_feature.updated_at = Time.now
    new_bam_to_fam_feature.step = step
#    new_bam_to_fam_feature.step_id = step_id
    new_bam_to_fam_feature
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
