class BusinessArea < ActiveRecord::Base
	acts_as_tree

  has_many :SubBusinessAreas, :class_name => "BusinessArea", :foreign_key => "parent_id"
  belongs_to :ParentBusinessArea, :class_name => "BusinessArea"
  belongs_to :iteration

  has_many :FunctionalWorkUnits, :dependent => :destroy
  has_many :Lbos, :dependent => :destroy
  has_many :watchings, :as => :watchable, :dependent => :destroy

  cattr_reader :per_page
  @@per_page = 30

	has_paper_trail :ignore => [:name]

	include Trackable

#	def as_json(options={})
#  	super(:only => :name, :include => {:SubBusinessAreas => {:only => :name}})
#  	super(:only => :name)
#	end

	def interested_parties
  	@interested_parties = []
	  @interested_parties << self.watchings.all
#	  @interested_parties << self.ParentBusinessArea.interested_parties if self.parent_id
	  @interested_parties.flatten.compact
	end

end
