class AfTask < ActiveRecord::Base
  establish_connection :agilefant
  set_table_name "tasks"

  belongs_to :story, :class_name => "AfStory", :foreign_key => "story_id"

end

