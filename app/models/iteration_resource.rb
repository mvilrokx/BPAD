class IterationResource < ActiveRecord::Base
  belongs_to :build_iteration
  belongs_to :af_user, :foreign_key => "user_id"
end
