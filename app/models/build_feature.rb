class BuildFeature < ActiveRecord::Base
	acts_as_tree

  belongs_to :buildable, :polymorphic => true
end
