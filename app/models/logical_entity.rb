class LogicalEntity < ActiveRecord::Base
  belongs_to :lba
  has_many :watchings, :as => :watchable, :dependent => :destroy
  has_many :logical_entity_attributes, :dependent => :destroy

 	include Trackable
end
