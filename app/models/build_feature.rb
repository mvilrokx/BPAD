class BuildFeature < ActiveRecord::Base
	acts_as_tree

  has_many :issues, :as => :issueable, :dependent => :destroy
  has_many :fam_to_tam_maps, :dependent => :destroy
  has_many :features, :through => :fam_to_tam_maps

  belongs_to :buildable, :polymorphic => true
end

