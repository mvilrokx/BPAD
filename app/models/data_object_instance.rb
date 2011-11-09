class DataObjectInstance < ActiveRecord::Base
  belongs_to :step
  belongs_to :business_process_element

	include Trackable

end

