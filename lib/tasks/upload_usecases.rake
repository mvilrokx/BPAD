desc "Upload Use Cases CSV"

task :upload_usecases, [:arg1] => :environment do |t, args|

  use_cases_file = args.arg1 || "useCasesFile.csv"
  open(use_cases_file) do |use_cases|
    puts "\nLoading Use Cases from file " + use_cases_file
    use_cases.read.each_line do |use_case|
      if !use_case.blank?
        business_process_name, path_name, description, tag_name = use_case.chomp.strip.split("|")
        bp = BusinessProcess.find_by_name(business_process_name)
        if bp
          path = Path.find_or_initialize_by_name(:name => path_name, :description => description, :business_process => bp)
          if tag_name
            tag = Tag.find_or_initialize_by_name(tag_name)
            path.tags << tag if !path.tags.include?(tag)
          end
          path.do_not_track = true
          path.save!
          print "."
        else
          puts "Skipped loading of " + use_case + " because the Business Process it is attached to ('" + business_process_name + "') does not exist."
        end
      end
    end
  end
  puts "\nDone!"
end

