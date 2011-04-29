class Watching < ActiveRecord::Base
  attr_accessible :user_id, :watchable_id, :watchable_type, :creator
  belongs_to :user
  belongs_to :watchable, :polymorphic => true
end
