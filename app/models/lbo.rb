class Lbo < ActiveRecord::Base
  # attr_accessible :business_area_id, :name

  belongs_to :business_area
  belongs_to :lba, :foreign_key => "business_area_id"
  
  has_many :watchings, :as => :watchable, :dependent => :destroy

	has_paper_trail :ignore => [:name]

	include Trackable

end
