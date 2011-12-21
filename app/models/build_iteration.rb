class BuildIteration < ActiveRecord::Base
  has_many :iteration_resources, :dependent => :destroy
  has_many :users, :through => :iteration_resources 
end
