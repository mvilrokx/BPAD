class FunctionalWorkUnit < ActiveRecord::Base
#  has_many :SubFunctionalWorkUnits, :class_name => "FunctionalWorkUnit", :foreign_key => "parent_id"
#  belongs_to :ParentFunctionalWorkUnit, :class_name => "FunctionalWorkUnit"

  belongs_to :business_area
  has_many :features, :dependent => :destroy
#  has_one :bam_to_fam_map, :dependent => :destroy
  has_many :watchings, :as => :watchable, :dependent => :destroy

#  has_many :bam_to_fam_maps, :dependent => :destroy
#  has_many :features, :through => :bam_to_fam_maps



	has_paper_trail :ignore => [:name]

	include Trackable
	include Watchable

	def interested_parties
  	@interested_parties = []
	  @interested_parties << self.watchings.all
	  @interested_parties << self.business_area.interested_parties
	  @interested_parties.flatten.compact
	end

end
