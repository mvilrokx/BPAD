class Interface < ActiveRecord::Base
  belongs_to :lba
  has_many :watchings, :as => :watchable, :dependent => :destroy
  
 	include Trackable

end
