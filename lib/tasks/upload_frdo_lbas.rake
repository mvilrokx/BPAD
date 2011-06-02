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
		lba = parent_lba_node.SubLbas.find_or_initialize_by_name(:name => lba_node['Name'])
	else
		lba = Lba.find_or_initialize_by_name_and_parent_id(:name => lba_node['Name'], :parent_id => nil)
	end
	lba.do_not_track = true
  if lba.save!
      puts "Successfully created LBA " + lba.name
  else
      puts "Error on " + lba.name
      lba.errors.each_full { |msg| puts msg }
  end

	lba_node.xpath('LBO').each do |lbo_node|
    create_lbo(lbo_node, lba)
	end

	lba_node.xpath('Interface').each do |interface_node|
    create_interface(interface_node, lba)
	end

	puts " - #{ lba_node['Name'] } - #{ lba_node['Level'] }"
	
	lba_node.xpath('LBA').each do |child_node|
		create_lba(child_node, lba)
	end
end

def create_lbo(lbo_node, parent_lba)
#  puts "entering create_lbo"
	lbo = parent_lba.lbos.find_or_initialize_by_name(:name => lbo_node['Name'])
  lbo.description = lbo_node['Description']
  lbo.do_not_track = true
  if lbo.save!
      puts "Successfully created business Object " + lbo.name
  else
      puts "Error on " + lbo.name
      lbo.errors.each_full { |msg| puts msg }
  end
 	lbo_node.xpath('LE').each do |le_node|
    create_le(le_node, lbo)
	end

#  puts "Leaving create_lbo"
end

def create_interface(interface_node, parent_lba)
#  puts "entering create_if"
	interface = parent_lba.interfaces.find_or_initialize_by_name(:name => interface_node['Name'])
  interface.do_not_track = true
  if interface.save!
      puts "Successfully created Interface " + interface.name
  else
      puts "Error on  " + interface.name
      interface.errors.each_full { |msg| puts msg }
  end

#  puts "Leaving create_lbo"
end

def create_le(le_node, parent_lbo)
#  puts "entering create_le"
	le = parent_lbo.logical_entities.find_or_initialize_by_name(:name => le_node['Name'])
	le.datedness = le_node['Datedness']=="DateEnabled"? true : false
  le.translation = le_node['Translation']=="Translated"? true : false
  le.do_not_track = true
  if le.save!
      puts "Successfully created Logical Entity " + le.name
  else
      puts "Error on  " + le.name
      le.errors.each_full { |msg| puts msg }
  end

	le_node.xpath('LEAttribute').each do |le_attr_node|
		create_le_attr(le_attr_node, le)
	end

#  puts "Leaving create_le"
end

def create_le_attr(le_attr_node, parent_le)
#  puts "entering create_le_attr"
	le_attr = parent_le.logical_entity_attributes.find_or_initialize_by_name(:name => le_attr_node['Name'])
	le_attr.mandatory = le_attr_node['NullValueAllowed']=="Y"? false : true
	le_attr.le_type = le_attr_node['Type']
  le_attr.do_not_track = true
  if le_attr.save!
      puts "Successfully created LE Attribute " + le_attr.name
  else
      puts "Error on  " + le_attr.name
      le_attr.errors.each_full { |msg| puts msg }
  end

#  puts "Leaving create_le_attr"
end

