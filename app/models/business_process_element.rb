class BusinessProcessElement < ActiveRecord::Base
  # attr_accessible :business_process_id, :name, :element_type, :xml_element_id

  belongs_to :business_process
  belongs_to :iteration
  has_many :flows
  has_many :steps
  has_many :target_elements, :through => :flows
  has_many :watchings, :as => :watchable, :dependent => :destroy

	# This is where you need to add BPMN2.0 Business Process Elements if there are other ones besides these
	# The Key is the name as it appears in the XML file.  Each value consists of another Hash where you can
	# define the name that is used on the display and whether a mapping is required for this element.
  ELEMENT_TYPES = {"startEvent" =>              {:display_name => "Start Event",        :mapping_required => false},
    							 "task" =>                    {:display_name => "Task",               :mapping_required => true},
    							 "userTask" =>                {:display_name => "User Task",          :mapping_required => true},
    							 "serviceTask" =>             {:display_name => "Service Task",       :mapping_required => true},
    							 "callActivity" =>            {:display_name => "Call Activity",      :mapping_required => false},
    							 "boundaryEvent" =>           {:display_name => "Boundary Event",     :mapping_required => false},
    							 "parallelGateway" =>         {:display_name => "Parallel Gateway",   :mapping_required => false},
    							 "exclusiveGateway" =>        {:display_name => "Exclusive Gateway",  :mapping_required => false},
    							 "inclusiveGateway" =>        {:display_name => "Inclusive Gateway",  :mapping_required => false},
    							 "intermediateThrowEvent" =>  {:display_name => "Data Object",        :mapping_required => false},
    							 "endEvent" =>                {:display_name => "End Event",          :mapping_required => false}
 	}

  validates_inclusion_of :element_type, :in => ELEMENT_TYPES.keys

	has_paper_trail :ignore => [:name]

	include Trackable

  named_scope :start_element, :conditions => "element_type = 'startEvent'"

  def start_element
  	target_elements.all(:conditions => "element_type = 'startEvent'")
	end

  def next_elements
  	target_elements.all(:conditions => "element_type <> 'intermediateThrowEvent'")
	end

  def produced_data_objects
  	target_elements.all(:conditions => "element_type = 'intermediateThrowEvent'")
	end

  def consumed_data_objects
    BusinessProcessElement.all(:joins => :flows, :conditions => "element_type = 'intermediateThrowEvent' AND flows.target_element_id = #{id}")
	end

end

