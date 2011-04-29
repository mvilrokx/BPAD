class Flow < ActiveRecord::Base
  # attr_accessible :business_process_element_id, :target_element_id, :xml_element_id

  belongs_to :business_process_element
  belongs_to :target_element, :class_name => 'BusinessProcessElement', :foreign_key => 'target_element_id'
  has_many :watchings, :as => :watchable, :dependent => :destroy

	has_paper_trail

	include Trackable

end
