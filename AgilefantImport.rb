for bp in BusinessProcess.all
  puts "Processing Business Process #{bp.name}"
  backlog=AfBacklog.find_from_or_create_in_agilefant(bp)

  puts "Created/Found #{backlog.backlogtype} Backlog #{backlog.name}"

  for path in bp.paths
    puts "  Processing Path #{path.name}"

    story=backlog.stories.build
    story.initialize_from_bpad(path)
    story.save!
    puts "  Created Story #{story.name}"

    label = AfLabel.new(:name => "path.id=#{path.id.to_s}",
                        :displayName => "path.id=#{path.id.to_s}",
                        :creator_id => 1,
                        :timestamp => Time.now)

    label.story_id = story.id
    label.save
    puts "  Created Label #{label.name}"

    for bf in path.build_features
      puts "    Processing Build Feature  #{bf.name}"
      sub_story = story.children.new
      sub_story.initialize_from_bpad(bf)
      sub_story.save!
      puts "    Created Story #{story.name}"

      label = AfLabel.new(:name => "build_feature.id=#{bf.id.to_s}",
                          :displayName => "build_feature.id=#{bf.id.to_s}",
                          :creator_id => 1,
                          :timestamp => Time.now)

      label.story_id = sub_story.id
      label.save
      puts "    Created Label #{label.name}"

    end
  end
end

