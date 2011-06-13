class AfLabel < ActiveRecord::Base
  establish_connection :agilefant
  set_table_name "labels"

  belongs_to :story, :class_name => "AfStory", :foreign_key => "story_id"

end

