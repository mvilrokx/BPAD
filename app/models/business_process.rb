class BusinessProcess < ActiveRecord::Base

  has_many :business_process_elements, :dependent => :destroy
  has_many :paths, :dependent => :destroy
  accepts_nested_attributes_for :business_process_elements
  has_many :watchings, :as => :watchable, :dependent => :destroy
  belongs_to :iteration

	has_attached_file :bpmn #, :styles => { :original => { :not_used => :not_used } },
                          #  :processors => [:bpmn_xml]

	after_save :parse_xml, :if => "self.changed.include?('bpmn_file_name')"

  cattr_reader :per_page
  @@per_page = 30

	has_paper_trail :ignore => [:name]

	include Trackable

	def url(*args)
		bpmn.url(*args)
	end

	def file_name
		bpmn_file_name
	end

	def content_type
		bpmn_content_type
	end

	def file_size
		bpmn_file_size
	end

	def interested_parties
  	@interested_parties = []
	  @interested_parties << self.watchings.all
	  @interested_parties.flatten.compact
	end

	protected
		def parse_xml
			p self.changed
      bp_elements = Hash.new
      xml = Nokogiri::XML(File.new(self.bpmn.path))

			# Added to remove namespaces, don't know how else to get this to work
	    # xml.remove_namespaces!

      process = xml.xpath('//xmlns:process[1]')
      process.xpath('xmlns:task | ' +
                    'xmlns:userTask | ' +
                    'xmlns:serviceTask | ' +
                    'xmlns:callActivity | ' +
                    'xmlns:startEvent | ' +
                    'xmlns:boundaryEvent | ' +
                    'xmlns:parallelGateway | ' +
                    'xmlns:exclusiveGateway | ' +
                    'xmlns:inclusiveGateway | ' +
                    'xmlns:intermediateThrowEvent | ' +
                    'xmlns:endEvent').each do |bp_element|
#          element = self.business_process_elements.build(:element_type => bp_element.name,
#                                                         :name => bp_element['name'])

          element = self.business_process_elements.find_or_initialize_by_xml_element_id(bp_element['id'])
          element.element_type = bp_element.name
          element.name = bp_element['name']

          if element.save!
              puts "Successfully created business process elements."
              bp_elements[bp_element['id']] = element
          else
              puts "Error."
              element.errors.each_full { |msg| puts msg }
          end
      end

			# Clean up Elements that have disappeared from the diagram (they must have been deleted)
			self.business_process_elements.all.each do |element|
				if !bp_elements[element.xml_element_id]
#					element.destroy
					puts "DELETE BP Element"
				end
			end

      process.xpath('xmlns:sequenceFlow').each do |arrow|
#          flow = Flow.new(:business_process_element_id => bp_elements[arrow['sourceRef']].id,
#                          :target_element_id => bp_elements[arrow['targetRef']].id)
          flow = Flow.find_or_initialize_by_business_process_element_id_and_target_element_id(bp_elements[arrow['sourceRef']].id, bp_elements[arrow['targetRef']].id)
          if flow.save!
              puts "Successfully created Flow."
          else
              puts "Error."
              flow.errors.each_full { |msg| puts msg }
          end
      end

	end
end
