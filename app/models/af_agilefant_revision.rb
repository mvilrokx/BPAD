class AfAgilefantRevision < ActiveRecord::Base
  establish_connection :agilefant
  set_table_name "agilefant_revisions"

  REVISION_TYPES = {:create => 0,
                    :update => 1,
                    :delete => 2}

  has_many :backlog_auds, :class_name => "AfBacklogAud", :foreign_key => "REV"
  has_many :story_auds, :class_name => "AfStoryAud", :foreign_key => "REV"

end
