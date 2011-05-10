class BamToFamMap < ActiveRecord::Base
  has_many :approvals, :as => :approvable, :dependent => :destroy

  belongs_to :step
  has_many :bam_to_fam_features, :dependent => :destroy
  accepts_nested_attributes_for :bam_to_fam_features, :allow_destroy => true

  cattr_reader :per_page
  @@per_page = 30

	has_paper_trail

	include Trackable

#	after_update :unmap_and_unapprove
#	after_create :add_approvals

#	protected
#		def unmap_and_unapprove
#			puts "unmap_and_unapprove"
#			step.unmap! if step.mapped?
#			approvals.each do |a|
#				a.unapprove!
#				a.approval_date = nil
#			end
#			add_approvals
#		end

#		def add_approvals
#		  for bam_to_fam_feature in self.bam_to_fam_features
#		    for watching in bam_to_fam_feature.interested_parties
#    			approvals.find_or_create_by_user_id(watching[:user_id]) if watching[:user_id]
#		    end
#		  end
#		end

end
