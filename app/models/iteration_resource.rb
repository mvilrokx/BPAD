class IterationResource < ActiveRecord::Base
  belongs_to :build_iteration
  belongs_to :user
end
