class AfStoryAud < ActiveRecord::Base
  establish_connection :agilefant
  set_table_name "stories_AUD"

  belongs_to :agilefant_revision, :class_name => "AfAgilefantRevision", :foreign_key => "REV"

end

