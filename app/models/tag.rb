class Tag < ActiveRecord::Base
  has_many :taggings, :dependent => :destroy
  has_many :paths, :through => :taggings
end
