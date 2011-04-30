class FunctionalWorkUnit < ActiveRecord::Base
#  has_many :SubFunctionalWorkUnits, :class_name => "FunctionalWorkUnit", :foreign_key => "parent_id"
#  belongs_to :ParentFunctionalWorkUnit, :class_name => "FunctionalWorkUnit"

  belongs_to :business_area
  has_many :features, :dependent => :destroy
#  has_one :bam_to_fam_map, :dependent => :destroy
  has_many :watchings, :as => :watchable, :dependent => :destroy

#  has_many :bam_to_fam_maps, :dependent => :destroy
#  has_many :features, :through => :bam_to_fam_maps

#  named_scope :non_mapped_features, lambda { |step_id| { :limit => step_id } }

	has_paper_trail :ignore => [:name]

	include Trackable
	include Watchable

	def interested_parties
  	@interested_parties = []
	  @interested_parties << self.watchings.all
	  @interested_parties << self.business_area.interested_parties
	  @interested_parties.flatten.compact
	end

	def non_mapped_features(step_id)
  	@non_mapped_features = self.features.all(:select => "id, name",
        :conditions => ["id not in (select feature_id from bam_to_fam_features where step_id=?)", step_id])
	end

end
