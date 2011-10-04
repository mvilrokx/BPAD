class WorkAssignment < ActiveRecord::Base
#  attr_accessible :af_user_id, :path_id

  belongs_to :user
  belongs_to :role
  belongs_to :path
end

