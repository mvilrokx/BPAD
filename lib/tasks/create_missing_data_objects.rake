desc "Create the missing Data Objects PLaceholders in eahc path, both producing and consuming"

task :create_missing_data_objects => :environment do
  BusinessProcess.all.each do |bp|
    bp.paths.each do |path|
      path.steps.each do |step|
        # create producing data object
        step.business_process_element.produced_data_objects.each do |element|
          produced_do = step.data_object_instances.find_by_business_process_element_id(element.id)
          if !produced_do
            puts "Creating new Producing Data Object '#{element.name}' for BP ''#{bp.name}', Path '#{path.name}', Step '#{step.element_name}'"
            step.data_object_instances.create(:business_process_element_id => element.id, :do_not_track => true)
          end
        end
        # create consuming data object
        step.business_process_element.consumed_data_objects.each do |element|
          consumed_do = step.data_object_instance_usages.find_by_business_process_element_id(element.id)
          if !consumed_do
            puts "Creating new Consuming Data Object '#{element.name}' for BP ''#{bp.name}', Path '#{path.name}', Step '#{step.element_name}'"
            step.data_object_instance_usages.create(:business_process_element_id => element.id, :do_not_track => true)
          end

        end
      end
    end
  end
end

