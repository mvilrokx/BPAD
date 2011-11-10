class DataObjectInstance < ActiveRecord::Base
  belongs_to :step
  belongs_to :business_process_element
  has_many :data_object_instance_usages

	include Trackable

end

