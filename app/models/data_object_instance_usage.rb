class DataObjectInstanceUsage < ActiveRecord::Base
  belongs_to :step
  belongs_to :business_process_element
  belongs_to :date_object_instance

	include Trackable

end

