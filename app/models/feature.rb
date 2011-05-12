class Feature < ActiveRecord::Base
  belongs_to :functional_work_unit
#  has_many :bam_to_fam_features
  has_many :watchings, :as => :watchable, :dependent => :destroy

  has_many :bam_to_fam_map_features #, :dependent => :destroy
  has_many :steps, :through => :bam_to_fam_map_features

  PRIORITY = ["Must Have", "Should Have", "Nice to Have"]
  FEATURE_TYPES = ["Business Rule", "UI", "Miscellaneous"]

  validates_inclusion_of :priority, :in => PRIORITY

	has_paper_trail :ignore => [:name]

	include Trackable
	include Watchable

	def fwu_feature
	  "#{functional_work_unit.name}: #{name}"
	end

	def mapped_to_step?(step_id)
	  self.bam_to_fam_map_features.find(:step_id => step_id)
	end

	def interested_parties
  	@interested_parties = []
	  @interested_parties << self.watchings.all
	  @interested_parties << self.functional_work_unit.interested_parties
	  @interested_parties.flatten.compact
	end


end
