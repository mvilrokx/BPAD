desc "Upload FRDO XML"

task :upload_frdo => :environment do
  require 'nokogiri'
  require 'open-uri'

#  Dir.glob("*.xml").each do |filename|
  Dir.glob("frdo.xml").each do |filename|
#  	puts filename
    xml = Nokogiri::XML(File.new(filename))
		xml.root.xpath('//LBA[@Level="TOP1"]').each do |node|
	    create_lba(node, nil)
	  end
  end
end

def create_lba(lba_node, parent_lba_node)
	if parent_lba_node then
		lba = parent_lba_node.SubBusinessAreas.new(:name => lba_node['Name'], :skip_tracking => true)
	else
		lba = BusinessArea.new(:name => lba_node['Name'], :parent_id => nil, :skip_tracking => true)
	end
  if lba.save!
      puts "Successfully created business area."
  else
      puts "Error."
      lba.errors.each_full { |msg| puts msg }
  end

	lba_node.xpath('LBO').each do |lbo|
		lbo = lba.Lbos.new(:name => lbo['Name'])
    if lbo.save!
        puts "Successfully created business Object."
    else
        puts "Error."
        lbo.errors.each_full { |msg| puts msg }
    end
	end

#	puts " - #{ lba_node['Name'] } - #{ lba_node['Level'] }"
	lba_node.xpath('LBA').each do |child_node|
		create_lba(child_node, lba)
	end
end
