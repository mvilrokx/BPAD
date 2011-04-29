desc "Upload FRDO FDD XML"

task :upload_frdo_fdd => :environment do
  require 'nokogiri'
  require 'open-uri'

  fdd_lba = BusinessArea.find_or_initialize_by_name('FDDs', {:parent_id => nil, :do_not_track => true})
	fdd_lba.do_not_track = true # Make sure this is set if found in DB
  if fdd_lba.save!
      puts "Successfully created business area."
  else
      puts "Error."
      fdd_lba.errors.each_full { |msg| puts msg }
  end

  Dir.glob("/scratch/mvilrokx/view_storage/mvilrokx_frdo/fusionapps/hcm/hxt/noship/frdo/definitions/hxt/functional/functionalDesignDocuments/Fdd*.xml").each do |filename|
  	puts filename
    xml = Nokogiri::XML(File.new(filename))
		xml.root.xpath('//xmlns:FunctionalDesignDocument').each do |fwu_node|
			fwu = fdd_lba.FunctionalWorkUnits.find_or_initialize_by_name(fwu_node['Name'].blank? ? "No Name" : fwu_node['Name'], {:do_not_track => true})
			fwu.do_not_track = true # Make sure this is set if found in DB
      if fwu.save!
          puts "Successfully created FWU."
      else
          puts "Error."
          fwu.errors.each_full { |msg| puts msg }
      end

			fwu_node.xpath('xmlns:FddFeature').each do |feature_node|
				puts feature_node.xpath('xmlns:Description').text
				feature = fwu.features.find_or_initialize_by_name(feature_node['Name'].blank? ? "No Name" : feature_node['Name'], {:priority => feature_node['Priority'], :scope => feature_node['Scope'], :description => feature_node.xpath('xmlns:Description').text, :do_not_track => true})
				feature.do_not_track = true # Make sure this is set if found in DB
	      if feature.save!
  	        puts "Successfully created feature."
    	  else
      	    puts "Error."
        	  feature.errors.each_full { |msg| puts msg }
	      end
			end

  	end
  end
end
