class AfBacklogAud < ActiveRecord::Base
  establish_connection :agilefant
  set_table_name "backlogs_AUD"

  belongs_to :agilefant_revision, :class_name => "AfAgilefantRevision", :foreign_key => "REV"

end

