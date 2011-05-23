desc "Upload FRDO XML to Technical Model"

task :upload_frdo_lbas => :environment do
  require 'nokogiri'
  require 'open-uri'

  Dir.glob("tmp/frdo.xml").each do |filename|
  	puts "Loading file -> " + filename
    xml = Nokogiri::XML(File.new(filename))
		xml.root.xpath('//LBA[@Level="TOP1"]').each do |node|
	    create_lba(node, nil)
	  end
  end
end

def create_lba(lba_node, parent_lba_node)
	if parent_lba_node then
		lba = parent_lba_node.SubLbas.new(:name => lba_node['Name'], :do_not_track => true)
	else
		lba = Lba.new(:name => lba_node['Name'], :parent_id => nil, :do_not_track => true)
	end
  if lba.save!
      puts "Successfully created LBA."
  else
      puts "Error."
      lba.errors.each_full { |msg| puts msg }
  end

	lba_node.xpath('LBO').each do |lbo|
		lbo = lba.lbos.new(:name => lbo['Name'], :do_not_track => true)
    if lbo.save!
        puts "Successfully created business Object."
    else
        puts "Error."
        lbo.errors.each_full { |msg| puts msg }
    end
	end

	puts " - #{ lba_node['Name'] } - #{ lba_node['Level'] }"
	lba_node.xpath('LBA').each do |child_node|
		create_lba(child_node, lba)
	end
end
