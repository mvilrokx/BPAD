desc "Upload BPMN XML"

task :upload_model => :environment do
    require 'nokogiri'
    require 'open-uri'

    Dir.glob("*.xml").each do |filename|
#        bp = BusinessProcess.find_or_create_by_name(filename)
        bp = BusinessProcess.new(:name => filename)
        if bp.save!
            puts "Successfully created business process."
        else
            puts "Error."
            bp.errors.each_full { |msg| puts msg }
        end
        puts bp.name
        bp_elements = Hash.new
        xml = Nokogiri::XML(File.new(filename))
        process = xml.xpath('//semantic:process[1]')
        process.xpath('semantic:task | ' +
                      'semantic:startEvent | ' +
                      'semantic:parallelGateway | ' +
                      'semantic:exclusiveGateway | ' +
                      'semantic:inclusiveGateway | ' +
                      'semantic:endEvent').each do |bp_element|
            element = bp.business_process_elements.build(:element_type => bp_element.name,
                                                         :name => bp_element['name'])

            if element.save!
                puts "Successfully created business process elements."
                bp_elements[bp_element['id']] = element
            else
                puts "Error."
                element.errors.each_full { |msg| puts msg }
            end
        end

        process.xpath('semantic:sequenceFlow').each do |arrow|
            flow = Flow.new(:business_process_element_id => bp_elements[arrow['sourceRef']].id,
                            :target_element_id => bp_elements[arrow['targetRef']].id)
            if flow.save!
                puts "Successfully created Flow."
            else
                puts "Error."
                flow.errors.each_full { |msg| puts msg }
            end
        end
    end
end
