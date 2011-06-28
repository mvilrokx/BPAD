class DataObjectInstance < ActiveRecord::Base
#  attr_accessible :name, :step_id, :business_process_element_id, :iteration_id
  belongs_to :step
end

