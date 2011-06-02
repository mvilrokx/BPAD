class Lba < ActiveRecord::Base
	acts_as_tree

  has_many :SubLbas, :class_name => "Lba", :foreign_key => "parent_id"
  belongs_to :ParentLba, :class_name => "Lba"
  belongs_to :iteration

  has_many :lbos, :dependent => :destroy, :foreign_key => "business_area_id"
  has_many :interfaces, :dependent => :destroy
  has_many :build_features, :as => :buildable
  
  before_save :set_parent_id_to_null_for_root

	include Trackable

  protected
    def set_parent_id_to_null_for_root
      self.parent_id = nil if parent_id == 0
    end
    
end
