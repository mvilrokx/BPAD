class LogicalEntityAttribute < ActiveRecord::Base
  belongs_to :logical_entity
  has_many :watchings, :as => :watchable, :dependent => :destroy
  
 	include Trackable
end
