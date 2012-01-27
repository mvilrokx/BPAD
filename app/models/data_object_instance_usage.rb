class DataObjectInstanceUsage < ActiveRecord::Base
  belongs_to :step
  belongs_to :business_process_element
  belongs_to :data_object_instance

	include Trackable

end

